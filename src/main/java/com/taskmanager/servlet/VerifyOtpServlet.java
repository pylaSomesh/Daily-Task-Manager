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

@WebServlet("/verifyOtp")
public class VerifyOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OtpDAO otpDAO;

    @Override
    public void init() throws ServletException {
        otpDAO = new OtpDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("resetEmail") == null) {
            response.sendRedirect("forgotPassword");
            return;
        }

        request.setAttribute("resetEmail", session.getAttribute("resetEmail"));
        request.setAttribute("otpSource", session.getAttribute("otpSource"));

        request.getRequestDispatcher("verify-otp.jsp")
               .forward(request, response);
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
        String otp = request.getParameter("otp");

        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Please enter the OTP.");
            request.setAttribute("resetEmail", email);
            request.getRequestDispatcher("verify-otp.jsp")
                   .forward(request, response);
            return;
        }

        if (!otpDAO.verifyOtp(email, otp.trim())) {
            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Invalid or expired OTP.");
            request.setAttribute("resetEmail", email);
            request.getRequestDispatcher("verify-otp.jsp")
                   .forward(request, response);
            return;
        }

        session.setAttribute("otpVerified", Boolean.TRUE);
        response.sendRedirect("resetPassword");
    }
}
