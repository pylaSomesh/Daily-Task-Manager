package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.OtpDAO;
import com.taskmanager.dao.UserDAO;
import com.taskmanager.model.User;
import com.taskmanager.util.EmailUtil;
import com.taskmanager.util.MailConfig;
import com.taskmanager.util.OtpUtil;
import com.taskmanager.util.ToastUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private OtpDAO otpDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        otpDAO = new OtpDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("forgot-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Email is required.");
            request.getRequestDispatcher("forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "No account found with that email address.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        int expiryMinutes = MailConfig.getOtpExpiryMinutes();
        String otp = OtpUtil.generateOtp();

        if (!otpDAO.saveOtp(email, otp, OtpUtil.expiryTime(expiryMinutes))) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Failed to generate OTP. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        if (!EmailUtil.sendOtpEmail(email, otp, expiryMinutes)) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Failed to send OTP email. Check mail configuration.");
            request.getRequestDispatcher("forgot-password.jsp")
                   .forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("resetEmail", email);
        session.setAttribute("otpSource", "login");
        session.removeAttribute("otpVerified");

        ToastUtil.flash(session, "success", "OTP sent to your email address.");
        response.sendRedirect("verifyOtp");
    }
}
