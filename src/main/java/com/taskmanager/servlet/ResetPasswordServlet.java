package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.UserDAO;
import com.taskmanager.util.PasswordUtil;
import com.taskmanager.util.ToastUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("resetEmail") == null
                || !Boolean.TRUE.equals(session.getAttribute("otpVerified"))) {
            response.sendRedirect("forgotPassword");
            return;
        }

        request.setAttribute("resetEmail", session.getAttribute("resetEmail"));
        request.getRequestDispatcher("reset-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("resetEmail") == null
                || !Boolean.TRUE.equals(session.getAttribute("otpVerified"))) {
            response.sendRedirect("forgotPassword");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.length() < 8) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Password must be at least 8 characters.");
            request.getRequestDispatcher("reset-password.jsp")
                   .forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Passwords do not match.");
            request.getRequestDispatcher("reset-password.jsp")
                   .forward(request, response);
            return;
        }

        var user = userDAO.getUserByEmail(email);

        if (user == null || !userDAO.updatePassword(user.getId(), PasswordUtil.hash(newPassword))) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Failed to reset password.");
            request.getRequestDispatcher("reset-password.jsp")
                   .forward(request, response);
            return;
        }

        session.removeAttribute("resetEmail");
        session.removeAttribute("otpVerified");
        session.removeAttribute("otpSource");
        session.removeAttribute("user");

        ToastUtil.flash(session, "success",
                "Password reset successfully. Please sign in.");
        response.sendRedirect("login.jsp");
    }
}
