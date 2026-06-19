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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

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

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User user = userDAO.getUserById(sessionUser.getId());

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        user.setPassword(null);
        request.setAttribute("profileUser", user);

        request.getRequestDispatcher("profile.jsp")
               .forward(request, response);
    }
}
