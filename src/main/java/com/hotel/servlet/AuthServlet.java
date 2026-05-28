package com.hotel.servlet;

import com.hotel.dao.UserDAO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/login", "/register", "/logout", "/forgot-password", "/api/auth/delete-account"})
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            res.sendRedirect(req.getContextPath() + "/login?msg=loggedout");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views" + path + ".jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if ("/register".equals(req.getServletPath())) {
            register(req, res);
        } else if ("/forgot-password".equals(req.getServletPath())) {
            resetPassword(req, res);
        } else {
            login(req, res);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!"/api/auth/delete-account".equals(req.getServletPath())) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User authUser = session != null ? (User) session.getAttribute("authUser") : null;
        if (authUser == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(res, false, "Please sign in again before deleting your account.");
            return;
        }

        try {
            boolean deleted = userDAO.deleteAccount(authUser.getId());
            if (!deleted) {
                res.setStatus(HttpServletResponse.SC_NOT_FOUND);
                writeJson(res, false, "Account could not be found.");
                return;
            }

            session.invalidate();
            writeJson(res, true, "Account deleted successfully.");
        } catch (Exception e) {
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeJson(res, false, "Could not delete your account. Please try again.");
        }
    }

    private void login(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        try {
            User user = userDAO.authenticate(email, password != null ? password : "");
            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, res);
                return;
            }
            req.getSession(true).setAttribute("authUser", user);
            res.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void register(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = trim(req.getParameter("name"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String password = req.getParameter("password");

        if (name.isEmpty() || email.isEmpty() || password == null || password.length() < 4) {
            req.setAttribute("error", "Name, email, and a password of at least 4 characters are required.");
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "An account already exists for that email.");
                req.setAttribute("name", name);
                req.setAttribute("email", email);
                req.setAttribute("phone", phone);
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, res);
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole("User");
            userDAO.register(user, password);

            User authenticated = userDAO.authenticate(email, password);
            req.getSession(true).setAttribute("authUser", authenticated);
            res.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void resetPassword(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = trim(req.getParameter("email"));
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (email.isEmpty()) {
            req.setAttribute("error", "No account found with these details.");
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, res);
            return;
        }
        if (newPassword == null || newPassword.length() < 4) {
            req.setAttribute("error", "New password must be at least 4 characters.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, res);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, res);
            return;
        }

        try {
            User user = userDAO.getByEmail(email);
            if (user == null) {
                req.setAttribute("error", "No account found with these details.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, res);
                return;
            }

            userDAO.updatePassword(user.getId(), newPassword);
            res.sendRedirect(req.getContextPath() + "/login?msg=passwordReset");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void writeJson(HttpServletResponse res, boolean success, String message) throws IOException {
        res.getWriter().write("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
    }

    private String escapeJson(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
