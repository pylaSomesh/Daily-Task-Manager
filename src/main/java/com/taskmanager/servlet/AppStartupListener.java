package com.taskmanager.servlet;

import com.taskmanager.util.ReminderScheduler;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener
        implements ServletContextListener {

    @Override
    public void contextInitialized(
            ServletContextEvent sce) {

       

        ReminderScheduler.start();
    }

    @Override
    public void contextDestroyed(
            ServletContextEvent sce) {

        System.out.println(
                "Application Stopped.");
    }
}