package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.UserDAO;
import com.taskmanager.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        // Check if username already exists
        if (userDAO.usernameExists(username)) {

            request.setAttribute("errorMessage",
                    "Username is already taken. Please choose a different name.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email)) {

            request.setAttribute("errorMessage",
                    "Email already registered. Please use a different email or sign in.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);

            return;
        }

        User user = new User();

        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        boolean registered = userDAO.registerUser(user);

        if (registered) {

            response.sendRedirect("login.jsp");

        } else {

            request.setAttribute("errorMessage",
                    "Registration failed");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
        }
    }
}
