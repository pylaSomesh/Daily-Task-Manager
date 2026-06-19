package com.taskmanager.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.TaskReminder;

public class TaskReminderService {

    public static void sendOverdueTaskReminders() {

        try {

            TaskDAO taskDAO =
                    new TaskDAO();

            List<TaskReminder> reminders =
                    taskDAO.getOverdueTaskReminders();

            Map<String,
                    List<TaskReminder>> grouped =
                    new HashMap<>();

            for (TaskReminder task
                    : reminders) {

                grouped.computeIfAbsent(
                        task.getEmail(),
                        k -> new java.util.ArrayList<>())
                        .add(task);
            }

            for (String email
                    : grouped.keySet()) {

                List<TaskReminder> userTasks =
                        grouped.get(email);

                String username =
                        userTasks.get(0)
                                 .getUsername();

                boolean sent =
                        EmailUtil.sendGroupedReminderEmail(
                                email,
                                username,
                                userTasks);

                if (sent) {

                	Logger logger =
                	        Logger.getLogger(
                	                TaskReminderService.class.getName());

                	logger.info(
                	        "Email sent to: " + email);

                } else {

                    System.out.println(
                            "Failed for: "
                                    + email);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}