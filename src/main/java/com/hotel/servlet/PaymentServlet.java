package com.hotel.servlet;

import com.hotel.dao.PaymentDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.model.Payment;
import com.hotel.model.Reservation;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/payments")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private ReservationDAO reservationDAO;

    @Override
    public void init() {
        paymentDAO = new PaymentDAO();
        reservationDAO = new ReservationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        User user = currentUser(req);
        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "add":
                    Payment payment = new Payment();
                    payment.setPaymentDate(LocalDate.now().toString());
                    payment.setPaymentMethod("Card");
                    payment.setStatus("Pending");
                    int reservationId = parseInt(req.getParameter("reservationId"), 0);
                    if (reservationId > 0) {
                        Reservation reservation = reservationDAO.getById(reservationId);
                        if (reservation != null && canUseReservation(user, reservation)) {
                            Payment existingPayment = user.isAdmin()
                                    ? paymentDAO.getByReservationId(reservationId)
                                    : paymentDAO.getByReservationIdForUser(reservationId, user.getId());
                            if (existingPayment != null) {
                                payment = existingPayment;
                            } else {
                                payment.setReservationId(reservationId);
                                payment.setAmount(reservation.getTotalAmount());
                            }
                        }
                    }
                    showForm(req, res, user, payment, "add", null);
                    break;
                case "edit":
                    Payment toEdit = findPayment(req, user);
                    if (toEdit == null) {
                        res.sendRedirect(req.getContextPath() + "/payments?error=notfound");
                        return;
                    }
                    showForm(req, res, user, toEdit, "edit", null);
                    break;
                case "delete":
                    Payment toDelete = findPayment(req, user);
                    if (toDelete != null) {
                        paymentDAO.delete(toDelete.getId());
                    }
                    res.sendRedirect(req.getContextPath() + "/payments?msg=deleted");
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
        try {
            Payment payment = bind(req, user);
            Reservation reservation = reservationDAO.getById(payment.getReservationId());
            if (reservation == null || !canUseReservation(user, reservation)) {
                showForm(req, res, user, payment, payment.getId() > 0 ? "edit" : "add",
                        "Select a valid reservation for this payment.");
                return;
            }
            payment.setUserId(reservation.getUserId());
            if (payment.getAmount() <= 0) {
                payment.setAmount(reservation.getTotalAmount());
            }
            boolean paidRequested = !user.isAdmin() || "Paid".equalsIgnoreCase(req.getParameter("status"));
            if (paidRequested) {
                String cardError = validateCardDetails(req);
                if (cardError != null) {
                    payment.setStatus("Pending");
                    showForm(req, res, user, payment, payment.getId() > 0 ? "edit" : "add", cardError);
                    return;
                }
                payment.setStatus("Paid");
            }

            if (payment.getId() > 0) {
                Payment existing = findPayment(req, user);
                if (existing == null) {
                    res.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                paymentDAO.update(payment);
                if (user.isAdmin()) {
                    res.sendRedirect(req.getContextPath() + "/payments?msg=updated");
                } else {
                    res.sendRedirect(req.getContextPath() + "/dashboard?msg=paymentUpdated");
                }
            } else {
                paymentDAO.insert(payment);
                if (user.isAdmin()) {
                    res.sendRedirect(req.getContextPath() + "/payments?msg=added");
                } else {
                    res.sendRedirect(req.getContextPath() + "/dashboard?msg=paymentAdded");
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void list(HttpServletRequest req, HttpServletResponse res, User user)
            throws Exception {
        req.setAttribute("payments", user.isAdmin() ? paymentDAO.getAll() : paymentDAO.getByUser(user.getId()));
        req.getRequestDispatcher("/WEB-INF/views/payments.jsp").forward(req, res);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse res, User user,
                          Payment payment, String mode, String error)
            throws Exception {
        req.setAttribute("form", payment);
        req.setAttribute("mode", mode);
        req.setAttribute("formError", error);
        req.setAttribute("reservations", user.isAdmin() ? reservationDAO.getAll() : reservationDAO.getByUser(user.getId()));
        req.setAttribute("payments", user.isAdmin() ? paymentDAO.getAll() : paymentDAO.getByUser(user.getId()));
        req.getRequestDispatcher("/WEB-INF/views/payments.jsp").forward(req, res);
    }

    private Payment bind(HttpServletRequest req, User user) {
        Payment payment = new Payment();
        payment.setId(parseInt(req.getParameter("id"), 0));
        payment.setReservationId(parseInt(req.getParameter("reservationId"), 0));
        payment.setAmount(parseDouble(req.getParameter("amount"), 0));
        payment.setPaymentMethod(req.getParameter("paymentMethod"));
        payment.setPaymentDate(defaultString(req.getParameter("paymentDate"), LocalDate.now().toString()));
        String status = req.getParameter("status");
        if (!user.isAdmin()) {
            status = "Pending";
        }
        payment.setStatus(defaultString(status, "Pending"));
        return payment;
    }

    private String validateCardDetails(HttpServletRequest req) {
        String cardNumber = trim(req.getParameter("cardNumber"));
        String expiryDate = trim(req.getParameter("expiryDate"));
        String cvv = trim(req.getParameter("cvv"));
        String cardholderName = trim(req.getParameter("cardholderName"));
        String cleanCardNumber = cardNumber.replaceAll("\\s", "");
        String cleanExpiry = expiryDate.replaceAll("\\s", "");

        if (cardNumber.isEmpty()) {
            return "Please enter card number.";
        }
        if (!cleanCardNumber.matches("\\d{13,19}")) {
            return "Please enter a valid card number.";
        }
        if (expiryDate.isEmpty()) {
            return "Please enter expiry date.";
        }
        if (!isValidExpiry(cleanExpiry)) {
            return "Please enter a valid expiry date.";
        }
        if (cvv.isEmpty()) {
            return "Please enter CVV.";
        }
        if (!cvv.matches("\\d{3,4}")) {
            return "Please enter a valid CVV.";
        }
        if (cardholderName.isEmpty()) {
            return "Please enter cardholder name.";
        }
        return null;
    }

    private boolean isValidExpiry(String cleanExpiry) {
        if (!cleanExpiry.matches("\\d{2}/\\d{2}")) {
            return false;
        }
        int month = parseInt(cleanExpiry.substring(0, 2), 0);
        return month >= 1 && month <= 12;
    }

    private Payment findPayment(HttpServletRequest req, User user) throws Exception {
        int id = parseInt(req.getParameter("id"), 0);
        return user.isAdmin() ? paymentDAO.getById(id) : paymentDAO.getByIdForUser(id, user.getId());
    }

    private boolean canUseReservation(User user, Reservation reservation) {
        return user.isAdmin() || reservation.getUserId() == user.getId();
    }

    private User currentUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("authUser");
    }

    private String defaultString(String value, String fallback) {
        return value == null || value.isEmpty() ? fallback : value;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseInt(String value, int fallback) {
        try {
            return value == null || value.isEmpty() ? fallback : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private double parseDouble(String value, double fallback) {
        try {
            return value == null || value.isEmpty() ? fallback : Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
