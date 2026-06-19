package com.taskmanager.util;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class ReminderScheduler {

    private static final ScheduledExecutorService scheduler =
            Executors.newSingleThreadScheduledExecutor();

    public static void start() {

        scheduler.scheduleAtFixedRate(

                () -> {

                   

                    TaskReminderService
                            .sendOverdueTaskReminders();

                },

                0,
                24,
                TimeUnit.HOURS);
        
//       24,
//       TimeUnit.HOURS
    }
}