package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.TaskDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/completeTask")
public class CompleteTaskServlet extends HttpServlet {

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

            boolean updated = taskDAO.markCompleted(taskId);

            if (updated) {
                response.sendRedirect("DashboardServlet");
            } else {
                response.sendRedirect("DashboardServlet?error=updatefailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
        }
    }
}