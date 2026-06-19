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

        List<Task> taskList =
                taskDAO.getTasksByUser(user.getId());

        int totalTasks = taskList.size();

        int completedTasks = 0;
        int pendingTasks = 0;

        for (Task task : taskList) {
            if ("Completed".equalsIgnoreCase(task.getStatus())) {
                completedTasks++;
            } else {
                pendingTasks++;
            }
        }

        request.setAttribute("taskList", taskList);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pendingTasks", pendingTasks);
        request.setAttribute("completedTasks", completedTasks);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);
    }
}