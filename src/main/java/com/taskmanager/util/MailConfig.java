package com.taskmanager.util;

import java.io.InputStream;
import java.util.Properties;

public final class MailConfig {
	
	

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = MailConfig.class.getClassLoader()
                .getResourceAsStream("mail.properties")) {
            if (in != null) {
                PROPS.load(in);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private MailConfig() {
    }

    public static String get(String key) {
        return PROPS.getProperty(key, "");
    }

    public static String get(String key, String defaultValue) {
        return PROPS.getProperty(key, defaultValue);
    }
    
    public static String getMailPassword() {

        String envPassword =
                System.getenv("MAIL_PASSWORD");

        if (envPassword != null &&
                !envPassword.isBlank()) {

            return envPassword;
        }

        return PROPS.getProperty(
                "mail.password",
                "");
    }

    public static int getOtpExpiryMinutes() {
        try {
            return Integer.parseInt(get("otp.expiry.minutes", "10"));
        } catch (NumberFormatException e) {
            return 10;
        }
    }
}
