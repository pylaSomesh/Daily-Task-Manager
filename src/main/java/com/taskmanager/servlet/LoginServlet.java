package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.UserDAO;
import com.taskmanager.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

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

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(email, password);

        if (user != null) {

            user.setPassword(null);

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect("DashboardServlet");

        } else {

            request.setAttribute("toastType", "error");
            request.setAttribute("toastMessage", "Invalid email or password.");

            request.getRequestDispatcher("login.jsp")
                   .forward(request, response);
        }
    }
}
