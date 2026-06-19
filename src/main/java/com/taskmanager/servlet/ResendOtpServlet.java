package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.OtpDAO;
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

@WebServlet("/resendOtp")
public class ResendOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OtpDAO otpDAO;

    @Override
    public void init() throws ServletException {
        otpDAO = new OtpDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("resetEmail") == null) {
            response.sendRedirect("forgotPassword");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        int expiryMinutes = MailConfig.getOtpExpiryMinutes();
        String otp = OtpUtil.generateOtp();

        if (!otpDAO.saveOtp(email, otp, OtpUtil.expiryTime(expiryMinutes))) {
            ToastUtil.flash(session, "error", "Failed to resend OTP.");
            response.sendRedirect("verifyOtp");
            return;
        }

        if (!EmailUtil.sendOtpEmail(email, otp, expiryMinutes)) {
            ToastUtil.flash(session, "error", "Failed to send OTP email.");
            response.sendRedirect("verifyOtp");
            return;
        }

        session.removeAttribute("otpVerified");
        ToastUtil.flash(session, "success", "A new OTP has been sent to your email.");
        response.sendRedirect("verifyOtp");
    }
}
