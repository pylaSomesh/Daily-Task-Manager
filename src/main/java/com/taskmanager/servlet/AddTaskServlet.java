package com.taskmanager.servlet;

import java.io.IOException;
import java.time.LocalDate;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import com.taskmanager.util.TaskCategoryUtil;
import com.taskmanager.util.ToastUtil;

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
        String priority = request.getParameter("priority");
        String category = request.getParameter("category");
        title = title == null ? "" : title.trim();
        dueDate = dueDate == null ? "" : dueDate.trim();
        priority = priority == null ? "" : priority.trim();
        category = category == null ? "" : category.trim();

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (priority == null || priority.trim().isEmpty()) {
            priority = "Medium";
        }
        
        if (category.length() > 50) {

            category = category.substring(0, 50);
        }
        category = TaskCategoryUtil.normalize(category);
        if (category.isEmpty()) {

            category = "General";
        }
        
        if (title.isEmpty()) {

            ToastUtil.flashRedirect(
                    response,
                    session,
                    "DashboardServlet",
                    "error",
                    "Task title is required.");

            return;
        }
        
        if (title.length() > 100) {

            ToastUtil.flashRedirect(
                    response,
                    session,
                    "DashboardServlet",
                    "error",
                    "Task title cannot exceed 100 characters.");

            return;
        }
        
        if (dueDate.isEmpty()) {
        	
        	try {

        	    LocalDate selectedDate =
        	            LocalDate.parse(dueDate);

        	    if (selectedDate.isBefore(LocalDate.now())) {

        	        ToastUtil.flashRedirect(
        	                response,
        	                session,
        	                "DashboardServlet",
        	                "error",
        	                "Due date cannot be in the past.");

        	        return;
        	    }

        	} catch (Exception e) {

        	    ToastUtil.flashRedirect(
        	            response,
        	            session,
        	            "DashboardServlet",
        	            "error",
        	            "Invalid due date.");

        	    return;
        	}

            ToastUtil.flashRedirect(
                    response,
                    session,
                    "DashboardServlet",
                    "error",
                    "Please select a due date.");

            return;
        }
        
        if (!priority.equals("Low") &&
        	    !priority.equals("Medium") &&
        	    !priority.equals("High")) {

        	    priority = "Medium";
        	}

        Task task = new Task();

        task.setTitle(title);
        task.setDueDate(dueDate);
        task.setPriority(priority);
        task.setCategory(category);
        task.setStatus("Pending");
        task.setUserId(user.getId());

        boolean added = taskDAO.addTask(task);

        if (added) {
            ToastUtil.flashRedirect(response, session,
                    "DashboardServlet", "success", "Task added successfully.");
        } else {
            ToastUtil.flashRedirect(response, session,
                    "DashboardServlet", "error", "Failed to add task.");
        }
    }
}
