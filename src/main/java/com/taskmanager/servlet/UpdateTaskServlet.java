package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import com.taskmanager.util.FilterQueryUtil;
import com.taskmanager.util.TaskCategoryUtil;
import com.taskmanager.util.ToastUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateTask")
public class UpdateTaskServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            User user = (User) session.getAttribute("user");

            int taskId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String dueDate = request.getParameter("dueDate");
            String priority = request.getParameter("priority");
            String category = request.getParameter("category");
            String search = request.getParameter("search");
            String statusFilter = request.getParameter("statusFilter");
            String categoryFilter = request.getParameter("categoryFilter");

            if (priority == null || priority.trim().isEmpty()) {
                priority = "Medium";
            }
            category = TaskCategoryUtil.normalize(category);

            Task task = new Task();
            task.setId(taskId);
            task.setTitle(title);
            task.setDueDate(dueDate);
            task.setPriority(priority);
            task.setCategory(category);
            task.setUserId(user.getId());

            boolean updated = taskDAO.updateTask(task);

            String query = FilterQueryUtil.build(search, statusFilter, categoryFilter);
            String redirectUrl = query.isEmpty()
                    ? "DashboardServlet"
                    : "DashboardServlet?" + query;

            if (updated) {
                ToastUtil.flashRedirect(response, session,
                        redirectUrl, "success", "Task updated successfully.");
            } else {
                ToastUtil.flashRedirect(response, session,
                        redirectUrl, "error", "Failed to update task.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
        }
    }
}
