package com.taskmanager.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.Task;
import com.taskmanager.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/monthTasks")
public class MonthTasksServlet extends HttpServlet {

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
                request.getParameter("month");

        TaskDAO dao =
                new TaskDAO();

        List<Task> tasks =
                dao.getTasksByMonth(
                        user.getId(),
                        month);

        response.setContentType(
                "application/json");

        PrintWriter out =
                response.getWriter();

        out.print("[");

        for(int i=0;i<tasks.size();i++){

            Task t = tasks.get(i);

            out.print("{");

            out.print("\"title\":\""
                    + t.getTitle()
                    + "\",");

            out.print("\"status\":\""
                    + t.getStatus()
                    + "\",");

            out.print("\"dueDate\":\""
                    + t.getDueDate()
                    + "\"");

            out.print("}");

            if(i < tasks.size()-1){
                out.print(",");
            }
        }

        out.print("]");
    }
}