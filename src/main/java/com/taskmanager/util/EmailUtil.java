package com.taskmanager.util;
import com.taskmanager.model.TaskReminder;

import java.util.List;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Message;

import jakarta.mail.Authenticator;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public final class EmailUtil {
	
	private static final Logger logger =
	        LoggerFactory.getLogger(
	                EmailUtil.class);

    private EmailUtil() {
    }

    public static boolean sendOtpEmail(String toEmail, String otp, int expiryMinutes) {
        try {
            String host = MailConfig.get("mail.smtp.host");
            String port = MailConfig.get("mail.smtp.port", "587");
            String username = MailConfig.get("mail.username");
            String password =
                    MailConfig.getMailPassword();
            String from = MailConfig.get("mail.from", username);
            String fromName = MailConfig.get("mail.from.name", "Daily Task Manager");

            if (host.isEmpty() || username.isEmpty() || password.isEmpty()) {
                System.err.println("Email configuration is incomplete. Update mail.properties.");
                return false;
            }

            Properties props = new Properties();
          
props.put("mail.smtp.host", host);
props.put("mail.smtp.port", "465");
props.put("mail.smtp.auth", "true");
props.put("mail.smtp.ssl.enable", "true");
			Properties props = new Properties();


            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, fromName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Daily Task Manager – Password Reset OTP");
            message.setContent(buildOtpHtml(otp, expiryMinutes), "text/html; charset=UTF-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {

            logger.error(
                    "Failed to send OTP email",
                    e);

            return false;
        }
    }

    
    public static boolean sendTaskReminderEmail(
            String email,
            String username,
            String taskTitle,
            String dueDate) {

        try {

            String host = MailConfig.get("mail.smtp.host");
            String port = MailConfig.get("mail.smtp.port", "587");
            String usernameConfig = MailConfig.get("mail.username");
            String password = MailConfig.getMailPassword();

            String from =
                    MailConfig.get("mail.from",
                            usernameConfig);

            String fromName =
                    MailConfig.get(
                            "mail.from.name",
                            "Daily Task Manager");

            Properties props = new Properties();

            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable",
                    "true");
            
            
           

            Session session = Session.getInstance(
                    props,
                    new Authenticator() {

                        @Override
                        protected PasswordAuthentication
                        getPasswordAuthentication() {

                            return new PasswordAuthentication(
                                    usernameConfig,
                                    password);
                        }
                    });

            MimeMessage message =
                    new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(
                            from,
                            fromName));

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(email));

            message.setSubject(
                    "Pending Task Reminder");

            String html =
                    "<html><body style='font-family:Segoe UI,Arial,sans-serif;'>"

                    + "<h2 style='color:#1f2937;'>"
                    + "Daily Task Manager"
                    + "</h2>"

                    + "<p>Hello "
                    + username
                    + ",</p>"

                    + "<p>"
                    + "We noticed that you have a pending task "
                    + "that has passed its due date."
                    + "</p>"

                    + "<div style='background:#f3f4f6;"
                    + "padding:15px;"
                    + "border-radius:8px;'>"

                    + "<p><strong>Task:</strong> "
                    + taskTitle
                    + "</p>"

                    + "<p><strong>Due Date:</strong> "
                    + dueDate
                    + "</p>"

                    + "</div>"

                    + "<p>"
                    + "Please log in and complete this task "
                    + "as soon as possible."
                    + "</p>"

                    + "<p>"
                    + "Stay productive! "
                    + "</p>"

                    + "<p>"
                    + "<strong>Daily Task Manager Team</strong>"
                    + "</p>"

                    + "</body></html>";

            message.setContent(
                    html,
                    "text/html; charset=UTF-8");

            Transport.send(message);

            return true;

        } catch (Exception e) {

            e.printStackTrace();
            return false;
        }
    }
    private static String buildOtpHtml(
            String otp,
            int expiryMinutes) {

        return "<!DOCTYPE html>"
                + "<html>"
                + "<body style='font-family:Segoe UI,Arial,sans-serif;"
                + "background:#f4f7fb;padding:24px;'>"

                + "<div style='max-width:520px;"
                + "margin:0 auto;"
                + "background:#ffffff;"
                + "border:1px solid #d8dee8;"
                + "border-radius:12px;"
                + "padding:28px;'>"

                + "<h2 style='color:#1f2937;'>"
                + "Daily Task Manager"
                + "</h2>"

                + "<p style='font-size:16px;color:#374151;'>"
                + "Hello User,"
                + "</p>"

                + "<p style='color:#5b6472;'>"
                + "Your password reset OTP is:"
                + "</p>"

                + "<div style='font-size:32px;"
                + "font-weight:800;"
                + "letter-spacing:6px;"
                + "color:#4a90d9;"
                + "background:#eef5fd;"
                + "border-radius:10px;"
                + "padding:16px;"
                + "text-align:center;'>"

                + otp

                + "</div>"

                + "<p style='color:#5b6472;margin-top:20px;'>"
                + "This OTP will expire in <strong>"
                + expiryMinutes
                + " minutes</strong>."
                + "</p>"

                + "<p style='color:#8b949e;'>"
                + "If you did not request a password reset,"
                + " you can safely ignore this email."
                + "</p>"

                + "<hr>"

                + "<p style='font-size:12px;color:#9ca3af;'>"
                + "Daily Task Manager Team"
                + "</p>"

                + "</div>"
                + "</body>"
                + "</html>";
    }
    
    
    
    public static boolean sendGroupedReminderEmail(
            String email,
            String username,
            List<TaskReminder> tasks) {

        try {

            String host =
                    MailConfig.get("mail.smtp.host");

            String port =
                    MailConfig.get(
                            "mail.smtp.port",
                            "587");

            String usernameConfig =
                    MailConfig.get(
                            "mail.username");

            String password =
                    MailConfig.getMailPassword();

            Properties props =
                    new Properties();

            props.put(
                    "mail.smtp.host",
                    host);

            props.put(
                    "mail.smtp.port",
                    port);

            props.put(
                    "mail.smtp.auth",
                    "true");

            props.put(
                    "mail.smtp.starttls.enable",
                    "true");

            Session session =
                    Session.getInstance(
                            props,
                            new Authenticator() {

                                @Override
                                protected PasswordAuthentication
                                getPasswordAuthentication() {

                                    return new PasswordAuthentication(
                                            usernameConfig,
                                            password);
                                }
                            });

            MimeMessage message =
                    new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(
                            usernameConfig,
                            "Daily Task Manager"));

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(email));

            message.setSubject(
                    "You Have Overdue Tasks");

            StringBuilder html =
                    new StringBuilder();

            html.append(
                    "<html><body style='font-family:Segoe UI;'>");

            html.append(
                    "<h2>Daily Task Manager</h2>");

            html.append(
                    "<p>Hello "
                    + username
                    + ",</p>");

            html.append(
                    "<p>You currently have "
                    + tasks.size()
                    + " overdue task(s):</p>");

            html.append("<ol>");

            for (TaskReminder task : tasks) {

                html.append(
                        "<li><strong>")
                    .append(task.getTitle())
                    .append("</strong><br>")
                    .append("Due Date: ")
                    .append(task.getDueDate())
                    .append("</li><br>");
            }

            html.append("</ol>");

            html.append(
                    "<p>Please review your dashboard and complete these tasks.</p>");

            html.append(
                    "<p>Stay productive! </p>");

            html.append(
                    "<p><strong>Daily Task Manager Team</strong></p>");

            html.append(
                    "</body></html>");

            message.setContent(
                    html.toString(),
                    "text/html; charset=UTF-8");

            Transport.send(message);

            return true;

        } catch (Exception e) {

            e.printStackTrace();
            return false;
        }
    }
}
