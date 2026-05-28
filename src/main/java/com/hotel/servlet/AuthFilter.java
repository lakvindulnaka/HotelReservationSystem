package com.hotel.servlet;

import com.hotel.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String contextPath = req.getContextPath();
        String path = req.getRequestURI().substring(contextPath.length());

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("authUser") : null;
        if (user == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Block non-admin users from management views only. Browsing hotels,
        // viewing rooms, and the reservation booking flow remain available.
        if (!user.isAdmin() && isAdminOnlyPath(path, req.getParameter("action"), req.getMethod())) {
            res.sendRedirect(contextPath + "/dashboard?error=forbidden");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("")
                || path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/login")
                || path.equals("/register")
                || path.equals("/forgot-password")
                || path.startsWith("/css/");
    }

    /**
     * Returns true for admin management pages/actions. Booking-flow actions
     * (reservations?action=add, success, edit own, cancel own) are allowed.
     */
    private boolean isAdminOnlyPath(String path, String action, String method) {
        boolean isGet = "GET".equalsIgnoreCase(method);
        boolean isListView = isGet && (action == null || action.isEmpty() || action.equals("list"));
        String normalizedAction = action == null ? "" : action.toLowerCase();

        if (path.equals("/hotels") && (normalizedAction.equals("add")
                || normalizedAction.equals("edit")
                || normalizedAction.equals("delete"))) return true;
        if (path.equals("/rooms") && (normalizedAction.equals("add")
                || normalizedAction.equals("edit")
                || normalizedAction.equals("delete"))) return true;
        if (path.equals("/reservations") && (isListView
                || normalizedAction.equals("delete"))) return true;
        if (path.equals("/payments") && isListView) return true;
        return false;
    }
}
