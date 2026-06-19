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

@WebServlet("/sendProfileOtp")
public class SendProfileOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private OtpDAO otpDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        otpDAO = new OtpDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User user = userDAO.getUserById(sessionUser.getId());

        if (user == null || user.getEmail() == null) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Unable to send OTP.");
            return;
        }

        String email = user.getEmail().trim().toLowerCase();
        int expiryMinutes = MailConfig.getOtpExpiryMinutes();
        String otp = OtpUtil.generateOtp();

        if (!otpDAO.saveOtp(email, otp, OtpUtil.expiryTime(expiryMinutes))) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Failed to generate OTP.");
            return;
        }

        if (!EmailUtil.sendOtpEmail(email, otp, expiryMinutes)) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Failed to send OTP email.");
            return;
        }

        session.setAttribute("resetEmail", email);
        session.setAttribute("otpSource", "profile");
        session.removeAttribute("otpVerified");

        ToastUtil.flash(session, "success", "OTP sent to your registered email.");
        response.sendRedirect("verifyOtp");
    }
}
