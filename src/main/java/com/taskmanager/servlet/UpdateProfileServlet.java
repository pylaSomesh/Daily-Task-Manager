package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.UserDAO;
import com.taskmanager.model.User;
import com.taskmanager.util.PasswordUtil;
import com.taskmanager.util.ToastUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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
        int userId = sessionUser.getId();

        String username =
                request.getParameter("username");

        String email =
                request.getParameter("email");

        username = username == null
                ? ""
                : username.trim();

        email = email == null
                ? ""
                : email.trim().toLowerCase();
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
        	String emailRegex =
        	        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

        	if (!email.matches(emailRegex)) {

        	    ToastUtil.flashRedirect(
        	            response,
        	            session,
        	            "profile",
        	            "error",
        	            "Please enter a valid email address.");

        	    return;
        	}
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Username and email are required.");
            return;
        }
        String emailRegex =
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

        if (!email.matches(emailRegex)) {

            ToastUtil.flashRedirect(
                    response,
                    session,
                    "profile",
                    "error",
                    "Please enter a valid email address.");

            return;
        }

        if (userDAO.usernameExistsForOtherUser(username.trim(), userId)) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Username is already taken.");
            return;
        }

        if (userDAO.emailExistsForOtherUser(email.trim(), userId)) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Email is already registered to another account.");
            return;
        }

        boolean passwordChangeRequested = newPassword != null
                && !newPassword.trim().isEmpty();

        if (passwordChangeRequested) {
        	
        	if (currentPassword.equals(newPassword)) {

        	    ToastUtil.flashRedirect(
        	            response,
        	            session,
        	            "profile",
        	            "error",
        	            "New password must be different from current password.");

        	    return;
        	}
            User storedUser = userDAO.getUserById(userId);

            if (storedUser == null
                    || !PasswordUtil.verify(currentPassword, storedUser.getPassword())) {
                ToastUtil.flashRedirect(response, session,
                        "profile", "error", "Current password is incorrect.");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                ToastUtil.flashRedirect(response, session,
                        "profile", "error", "New passwords do not match.");
                return;
            }

            if (newPassword.length() < 8) {
                ToastUtil.flashRedirect(response, session,
                        "profile", "error", "New password must be at least 8 characters.");
                return;
            }

            if (!userDAO.updatePassword(userId, PasswordUtil.hash(newPassword))) {
                ToastUtil.flashRedirect(response, session,
                        "profile", "error", "Failed to update password.");
                return;
            }
        }

        boolean updated = userDAO.updateProfile(userId, username.trim(), email.trim());

        if (!updated) {
            ToastUtil.flashRedirect(response, session,
                    "profile", "error", "Failed to update profile.");
            return;
        }

        User refreshedUser = userDAO.getUserById(userId);
        if (refreshedUser != null) {
            refreshedUser.setPassword(null);
            session.setAttribute("user", refreshedUser);
        }

        String message = passwordChangeRequested
                ? "Profile and password updated successfully."
                : "Profile updated successfully.";

        ToastUtil.flashRedirect(response, session,
                "profile", "success", message);
    }
}
