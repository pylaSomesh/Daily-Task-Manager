package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.TaskDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteTask")
public class DeleteTaskServlet extends HttpServlet {

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

        try {
            int taskId = Integer.parseInt(request.getParameter("id"));

            boolean deleted = taskDAO.deleteTask(taskId);

            if (deleted) {
                response.sendRedirect("DashboardServlet");
            } else {
                request.setAttribute("errorMessage",
                        "Failed to delete task.");
                request.getRequestDispatcher("DashboardServlet")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
        }
    }
}