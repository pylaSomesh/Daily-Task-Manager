package com.taskmanager.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.AnalyticsDTO;
import com.taskmanager.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/monthAnalytics")
public class MonthAnalyticsServlet
        extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if(session == null ||
           session.getAttribute("user") == null){

            return;
        }

        User user =
                (User) session.getAttribute("user");

        String month =
                request.getParameter(
                        "month");

        if(month == null ||
           month.isBlank()){

            month =
                java.time.LocalDate.now()
                .toString()
                .substring(0,7);
        }
        
        

        TaskDAO dao =
                new TaskDAO();

        AnalyticsDTO analytics =
                dao.getAnalyticsByMonth(
                        user.getId(),
                        month);

        response.setContentType(
                "application/json");

        PrintWriter out =
                response.getWriter();

        out.print("{");

        out.print("\"total\":"
                + analytics.getTotalTasks()
                + ",");

        out.print("\"completed\":"
                + analytics.getCompletedTasks()
                + ",");

        out.print("\"pending\":"
                + analytics.getPendingTasks()
                + ",");

        out.print("\"overdue\":"
                + analytics.getOverdueTasks()
                + ",");

        out.print("\"completionRate\":"
                + analytics.getCompletionRate());

        out.print("}");
    }
}