package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.util.ToastUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        HttpSession session = request.getSession(false);

        try {
            int taskId = Integer.parseInt(request.getParameter("id"));

            boolean deleted = taskDAO.deleteTask(taskId);

            if (deleted) {
                ToastUtil.flashRedirect(response, session,
                        "DashboardServlet", "success", "Task deleted successfully.");
            } else {
                ToastUtil.flashRedirect(response, session,
                        "DashboardServlet", "error", "Failed to delete task.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
        }
    }
}
