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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

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

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        username = username == null ? "" : username.trim();
        email = email == null ? "" : email.trim().toLowerCase();
        password = password == null ? "" : password;
        
        if (username.isEmpty()) {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Username is required.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }
        
        String emailRegex =
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

        if (email.isEmpty() || !email.matches(emailRegex)) {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Please enter a valid email address.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }
        if (password.length() < 8) {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Password must contain at least 8 characters.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }
        if (username.length() > 30) {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Username cannot exceed 30 characters.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }

        if (userDAO.usernameExists(username)) {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Username is already taken. Please choose a different name.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }

        if (userDAO.emailExists(email)) {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage",
                    "Email already registered. Please use a different email or sign in.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }

        User user = new User();

        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hash(password));

        boolean registered = userDAO.registerUser(user);

        if (registered) {

            HttpSession session = request.getSession(true);
            ToastUtil.flash(session, "success",
                    "Account created successfully. Please sign in.");

            response.sendRedirect("login.jsp");

        } else {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Registration failed. Please try again.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
        }
    }
}
