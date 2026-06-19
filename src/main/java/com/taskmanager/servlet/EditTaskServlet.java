package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.Task;
import com.taskmanager.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/editTask")
public class EditTaskServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskDAO taskDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
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

        try {
            User user = (User) session.getAttribute("user");
            int taskId = Integer.parseInt(request.getParameter("id"));

            Task task = taskDAO.getTaskByIdAndUser(taskId, user.getId());

            if (task == null) {
                response.sendRedirect("DashboardServlet");
                return;
            }

            request.setAttribute("task", task);
            request.setAttribute("search", request.getParameter("search"));
            request.setAttribute("statusFilter", request.getParameter("statusFilter"));
            request.setAttribute("categoryFilter", request.getParameter("categoryFilter"));

            request.getRequestDispatcher("edit-task.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
        }
    }
}
