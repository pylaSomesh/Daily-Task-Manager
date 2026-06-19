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

@WebServlet("/addTask")
public class AddTaskServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskDAO taskDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String dueDate = request.getParameter("dueDate");

        HttpSession session = request.getSession(false);

        User user = (User) session.getAttribute("user");

        Task task = new Task();

        task.setTitle(title);
        task.setDueDate(dueDate);
        task.setStatus("Pending");
        task.setUserId(user.getId());

        boolean added = taskDAO.addTask(task);

        if (added) {
            response.sendRedirect("DashboardServlet");
        } else {
            response.sendRedirect("dashboard.jsp?error=addfailed");
        }
    }
}