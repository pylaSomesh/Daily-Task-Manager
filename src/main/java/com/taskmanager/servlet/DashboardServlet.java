package com.taskmanager.servlet;

import java.io.IOException;
import java.util.List;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.Task;
import com.taskmanager.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskDAO taskDAO;

    @Override
    public void init() {
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

        User user = (User) session.getAttribute("user");

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");
        String categoryFilter = request.getParameter("categoryFilter");

        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "All";
        }
        if (categoryFilter == null || categoryFilter.trim().isEmpty()) {
            categoryFilter = "All";
        }

        List<Task> allTasks = taskDAO.getTasksByUser(user.getId());
        List<Task> taskList = taskDAO.searchTasksByUser(
                user.getId(), search, statusFilter, categoryFilter);

        int totalTasks = allTasks.size();

        int completedTasks = 0;
        int pendingTasks = 0;

        for (Task task : allTasks) {
            if ("Completed".equalsIgnoreCase(task.getStatus())) {
                completedTasks++;
            } else {
                pendingTasks++;
            }
        }

        double completionPercentage = 0.0;
        if (totalTasks > 0) {
            completionPercentage = (completedTasks * 100.0) / totalTasks;
        }

        request.setAttribute("taskList", taskList);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pendingTasks", pendingTasks);
        request.setAttribute("completedTasks", completedTasks);
        request.setAttribute("completionPercentage", completionPercentage);
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("categoryFilter", categoryFilter);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);
    }
}
