package com.hotel.servlet;

import com.hotel.dao.HotelDAO;
import com.hotel.dao.PaymentDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.dao.UserDAO;
import com.hotel.model.Hotel;
import com.hotel.model.Reservation;
import com.hotel.model.Room;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reservations")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;
    private RoomDAO        roomDAO;
    private UserDAO        userDAO;
    private HotelDAO       hotelDAO;
    private PaymentDAO     paymentDAO;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
        roomDAO        = new RoomDAO();
        userDAO        = new UserDAO();
        hotelDAO       = new HotelDAO();
        paymentDAO     = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user   = currentUser(req);
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    showForm(req, res, user, new Reservation(), "add", null);
                    break;
                case "edit":
                    Reservation toEdit = findReservation(req, user);
                    if (toEdit == null) {
                        res.sendRedirect(req.getContextPath() + "/reservations?error=notfound");
                        return;
                    }
                    showForm(req, res, user, toEdit, "edit", null);
                    break;
                case "success":
                    showSuccess(req, res, user);
                    break;
                case "cancel":
                    Reservation toCancel = findReservation(req, user);
                    if (toCancel != null) reservationDAO.cancel(toCancel.getId());
                    if (user.isAdmin()) {
                        res.sendRedirect(req.getContextPath() + "/reservations?msg=cancelled");
                    } else {
                        res.sendRedirect(req.getContextPath() + "/dashboard?msg=cancelled");
                    }
                    break;
                case "delete":
                    if (!user.isAdmin()) { res.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    reservationDAO.delete(parseInt(req.getParameter("id"), 0));
                    res.sendRedirect(req.getContextPath() + "/reservations?msg=deleted");
                    break;
                default:
                    list(req, res, user);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = currentUser(req);
        Reservation reservation = bind(req, user);

        try {
            Reservation existing  = reservation.getId() > 0 ? findReservation(req, user) : null;
            String roomError = validateRoom(reservation, existing);
            String dateError = validateDates(reservation);
            if (roomError != null || dateError != null) {
                showForm(req, res, user, reservation, reservation.getId() > 0 ? "edit" : "add",
                         roomError != null ? roomError : dateError);
                return;
            }

            if (reservation.getId() > 0) {
                if (existing == null) { res.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                if (!user.isAdmin()) {
                    reservation.setUserId(user.getId());
                    reservation.setStatus(existing.getStatus());
                }
                reservationDAO.update(reservation);
                if (user.isAdmin()) {
                    res.sendRedirect(req.getContextPath() + "/reservations?msg=updated");
                } else {
                    res.sendRedirect(req.getContextPath() + "/reservations?action=success&id=" + reservation.getId() + "&msg=updated");
                }
            } else {
                int newId = reservationDAO.insert(reservation);
                if (newId <= 0) {
                    showForm(req, res, user, reservation, "add",
                             "Reservation could not be created. Please check the details and try again.");
                    return;
                }
                Reservation created = reservationDAO.getById(newId);
                if (created != null) {
                    paymentDAO.createPendingForReservation(newId, created.getUserId(), created.getTotalAmount());
                }
                if (!user.isAdmin()) {
                    res.sendRedirect(req.getContextPath() + "/reservations?action=success&id=" + newId + "&msg=created");
                } else {
                    res.sendRedirect(req.getContextPath() + "/reservations?msg=added");
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void list(HttpServletRequest req, HttpServletResponse res, User user) throws Exception {
        if (user.isAdmin()) {
            req.setAttribute("reservations", reservationDAO.getAll());
        } else {
            req.setAttribute("reservations", reservationDAO.getByUser(user.getId()));
        }
        req.getRequestDispatcher("/WEB-INF/views/reservations.jsp").forward(req, res);
    }

    private void showSuccess(HttpServletRequest req, HttpServletResponse res, User user) throws Exception {
        int id = parseInt(req.getParameter("id"), 0);
        Reservation reservation = user.isAdmin()
                ? reservationDAO.getById(id)
                : reservationDAO.getByIdForUser(id, user.getId());
        if (reservation == null) {
            res.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        Room  room  = roomDAO.getById(reservation.getRoomId());
        Hotel hotel = (room != null && room.getHotelId() > 0) ? hotelDAO.getById(room.getHotelId()) : null;
        req.setAttribute("reservation", reservation);
        req.setAttribute("selectedRoom",  room);
        req.setAttribute("selectedHotel", hotel);
        req.getRequestDispatcher("/WEB-INF/views/reservation-success.jsp").forward(req, res);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse res, User user,
                          Reservation reservation, String mode, String error) throws Exception {
        // Pre-select room from URL param
        int roomIdParam = parseInt(req.getParameter("roomId"), 0);
        if (reservation.getRoomId() == 0 && roomIdParam > 0) {
            reservation.setRoomId(roomIdParam);
        }
        if (reservation.getStatus() == null)       reservation.setStatus("Pending");
        if (reservation.getNumberOfGuests() == 0)  reservation.setNumberOfGuests(1);

        // Pre-fill guest name/email from logged-in user if not already set
        if ((reservation.getFirstName() == null || reservation.getFirstName().isBlank())
                && user.getName() != null) {
            String[] parts = user.getName().split(" ", 2);
            reservation.setFirstName(parts[0]);
            if (parts.length > 1) reservation.setLastName(parts[1]);
        }

        // Load selected room + hotel for booking summary sidebar
        Room  selectedRoom  = null;
        Hotel selectedHotel = null;
        if (reservation.getRoomId() > 0) {
            selectedRoom = roomDAO.getById(reservation.getRoomId());
            if (selectedRoom != null && selectedRoom.getHotelId() > 0) {
                selectedHotel = hotelDAO.getById(selectedRoom.getHotelId());
            }
        }

        req.setAttribute("form",          reservation);
        req.setAttribute("mode",          mode);
        req.setAttribute("formError",     error);
        req.setAttribute("selectedRoom",  selectedRoom);
        req.setAttribute("selectedHotel", selectedHotel);
        req.setAttribute("rooms",         roomDAO.getAll());
        req.setAttribute("hotels",        hotelDAO.getAll());
        if (user.isAdmin()) {
            req.setAttribute("users", userDAO.getAllUsers());
        }
        req.getRequestDispatcher("/WEB-INF/views/reservation-form.jsp").forward(req, res);
    }

    private Reservation bind(HttpServletRequest req, User user) {
        Reservation r = new Reservation();
        r.setId(parseInt(req.getParameter("id"), 0));
        r.setUserId(user.isAdmin()
                ? parseInt(req.getParameter("userId"), user.getId())
                : user.getId());
        r.setRoomId(parseInt(req.getParameter("roomId"), 0));
        r.setCheckIn(req.getParameter("checkIn"));
        r.setCheckOut(req.getParameter("checkOut"));
        r.setNumberOfGuests(parseInt(req.getParameter("numberOfGuests"), 1));
        r.setStatus(user.isAdmin() ? req.getParameter("status") : "Pending");

        // Guest details
        r.setFirstName(req.getParameter("firstName"));
        r.setLastName(req.getParameter("lastName"));
        r.setPhone(req.getParameter("phone"));
        r.setCountry(req.getParameter("country"));
        r.setSpecialRequests(req.getParameter("specialRequests"));
        r.setBookingFor(req.getParameter("bookingFor"));
        r.setTravelingForWork("yes".equalsIgnoreCase(req.getParameter("travelingForWork")));
        r.setPaperlessConfirmation("on".equalsIgnoreCase(req.getParameter("paperlessConfirmation"))
                                || "true".equalsIgnoreCase(req.getParameter("paperlessConfirmation")));
        return r;
    }

    private Reservation findReservation(HttpServletRequest req, User user) throws Exception {
        int id = parseInt(req.getParameter("id"), 0);
        return user.isAdmin()
                ? reservationDAO.getById(id)
                : reservationDAO.getByIdForUser(id, user.getId());
    }

    private String validateRoom(Reservation reservation, Reservation existing) throws Exception {
        Room room = roomDAO.getById(reservation.getRoomId());
        if (room == null) return "Please select a valid room.";
        boolean sameRoom = existing != null && existing.getRoomId() == reservation.getRoomId();
        if (!room.isAvailable() && !sameRoom) {
            return "That room is not available — it is currently " + room.getStatus().toLowerCase() + ".";
        }
        int cap = room.getCapacity();
        if (cap > 0 && reservation.getNumberOfGuests() > cap) {
            return "This room holds a maximum of " + cap + " guest(s).";
        }
        return null;
    }

    private String validateDates(Reservation reservation) {
        try {
            LocalDate ci = LocalDate.parse(reservation.getCheckIn());
            LocalDate co = LocalDate.parse(reservation.getCheckOut());
            if (!co.isAfter(ci)) return "Check-out date must be after check-in date.";
        } catch (Exception e) {
            return "Enter valid check-in and check-out dates.";
        }
        if (reservation.getNumberOfGuests() < 1) return "Number of guests must be at least 1.";
        return null;
    }

    private User currentUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("authUser");
    }
    private int parseInt(String v, int fb) {
        try { return v == null || v.isEmpty() ? fb : Integer.parseInt(v); }
        catch (NumberFormatException e) { return fb; }
    }
}
