package com.taskmanager.servlet;

import java.io.IOException;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.AnalyticsDTO;
import com.taskmanager.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user =
                (User) session.getAttribute("user");

        TaskDAO dao =
                new TaskDAO();

        AnalyticsDTO analytics =
                dao.getAnalytics(
                        user.getId());

        request.setAttribute(
                "analytics",
                analytics);
        
        request.setAttribute(
                "monthlyData",
                dao.getMonthlyCompletedTasks(
                        user.getId()));

        request.setAttribute(
                "completedTasks",
                dao.getTasksByStatus(
                        user.getId(),
                        "Completed"));

        request.setAttribute(
                "pendingTasks",
                dao.getTasksByStatus(
                        user.getId(),
                        "Pending"));

        request.setAttribute(
                "overdueTasks",
                dao.getOverdueTasksByUser(
                        user.getId()));

        String filter =
                request.getParameter(
                        "filter");

        if (filter != null &&
            !filter.isEmpty()) {

            if ("Overdue".equalsIgnoreCase(filter)) {

                request.setAttribute(
                        "taskList",
                        dao.getOverdueTasksByUser(
                                user.getId()));

            } else {

                request.setAttribute(
                        "taskList",
                        dao.getTasksByStatus(
                                user.getId(),
                                filter));
            }

            request.setAttribute(
                    "selectedFilter",
                    filter);
        }

        request.getRequestDispatcher(
                "/analytics.jsp")
               .forward(
                request,
                response);
        request.setAttribute(
        	    "monthlyData",

        	    dao.getMonthlyCompletedTasks(
        	        user.getId()));
    }
}