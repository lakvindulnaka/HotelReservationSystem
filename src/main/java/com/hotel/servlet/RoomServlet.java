package com.hotel.servlet;

import com.hotel.dao.HotelDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.model.Hotel;
import com.hotel.model.Room;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {
    private RoomDAO  roomDAO;
    private HotelDAO hotelDAO;

    @Override
    public void init() {
        roomDAO  = new RoomDAO();
        hotelDAO = new HotelDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User   user   = currentUser(req);
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            // ── Delete ──────────────────────────────────────────────────────
            if ("delete".equals(action)) {
                if (!requireAdmin(user, res)) return;
                int deletedRoomHotelId = 0;
                Room toDelete = roomDAO.getById(parseInt(req.getParameter("id"), 0));
                if (toDelete != null) deletedRoomHotelId = toDelete.getHotelId();
                roomDAO.delete(parseInt(req.getParameter("id"), 0));
                res.sendRedirect(req.getContextPath() + "/rooms?hotelId=" + deletedRoomHotelId + "&msg=deleted");
                return;
            }

            // ── Form (add/edit) ─────────────────────────────────────────────
            Room   form = new Room();
            form.setStatus("Available");
            form.setCapacity(2);
            String mode = "add";

            if ("edit".equals(action)) {
                if (!requireAdmin(user, res)) return;
                form = roomDAO.getById(parseInt(req.getParameter("id"), 0));
                mode = "edit";
                if (form == null) {
                    res.sendRedirect(req.getContextPath() + "/rooms?error=notfound");
                    return;
                }
            } else if ("add".equals(action)) {
                if (!requireAdmin(user, res)) return;
                form.setHotelId(parseInt(req.getParameter("hotelId"), 0));
            }

            // ── Hotel / Room selection ──────────────────────────────────────
            int   selectedHotelId = parseInt(req.getParameter("hotelId"), 0);
            int   selectedRoomId  = parseInt(req.getParameter("roomId"),  0);
            Hotel selectedHotel   = null;
            Room  selectedRoom    = null;
            List<Room> rooms      = null;

            // View C: room detail
            if (selectedRoomId > 0) {
                selectedRoom = roomDAO.getById(selectedRoomId);
                if (selectedRoom != null) {
                    selectedHotelId = selectedRoom.getHotelId();
                    selectedHotel   = hotelDAO.getById(selectedHotelId);
                }
            }

            // View B: hotel room list
            if (selectedHotelId > 0) {
                if (selectedHotel == null) selectedHotel = hotelDAO.getById(selectedHotelId);
                rooms = roomDAO.getByHotel(selectedHotelId);
            }
            // View A (selectedHotelId == 0): rooms stays null, JSP shows hotel cards

            List<Hotel> hotels = hotelDAO.getAll();

            req.setAttribute("rooms",            rooms);
            req.setAttribute("hotels",           hotels);
            req.setAttribute("selectedHotel",    selectedHotel);
            req.setAttribute("selectedHotelId",  selectedHotelId);
            req.setAttribute("selectedRoom",     selectedRoom);
            req.setAttribute("selectedRoomId",   selectedRoomId);
            req.setAttribute("form",             form);
            req.setAttribute("mode",             mode);
            req.getRequestDispatcher("/WEB-INF/views/rooms.jsp").forward(req, res);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = currentUser(req);
        if (!requireAdmin(user, res)) return;
        req.setCharacterEncoding("UTF-8");
        Room room = bind(req);
        try {
            int hotelId = room.getHotelId();
            if (room.getId() > 0) {
                roomDAO.update(room);
                res.sendRedirect(req.getContextPath() + "/rooms?hotelId=" + hotelId + "&msg=updated");
            } else {
                roomDAO.insert(room);
                res.sendRedirect(req.getContextPath() + "/rooms?hotelId=" + hotelId + "&msg=added");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Room bind(HttpServletRequest req) {
        Room room = new Room();
        room.setId(parseInt(req.getParameter("id"), 0));
        room.setHotelId(parseInt(req.getParameter("hotelId"), 0));
        room.setRoomNumber(req.getParameter("roomNumber"));
        room.setRoomType(req.getParameter("roomType"));
        room.setPricePerNight(parseDouble(req.getParameter("pricePerNight"), 0));
        room.setCapacity(parseInt(req.getParameter("capacity"), 2));
        room.setStatus(req.getParameter("status"));
        room.setDescription(req.getParameter("description"));
        room.setImage(req.getParameter("image"));
        room.setBedType(req.getParameter("bedType"));
        room.setRoomSize(req.getParameter("roomSize"));
        room.setGallery(req.getParameter("gallery"));
        room.setFacilities(req.getParameter("facilities"));
        return room;
    }

    private boolean requireAdmin(User user, HttpServletResponse res) throws IOException {
        if (!user.isAdmin()) { res.sendError(HttpServletResponse.SC_FORBIDDEN); return false; }
        return true;
    }
    private User currentUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("authUser");
    }
    private int parseInt(String v, int fb) {
        try { return v == null || v.isEmpty() ? fb : Integer.parseInt(v); }
        catch (NumberFormatException e) { return fb; }
    }
    private double parseDouble(String v, double fb) {
        try { return v == null || v.isEmpty() ? fb : Double.parseDouble(v); }
        catch (NumberFormatException e) { return fb; }
    }
}
