package com.taskmanager.util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil {

    private PasswordUtil() {
    }

    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public static boolean verify(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        if (isHashed(storedPassword)) {
            return BCrypt.checkpw(plainPassword, storedPassword);
        }
        return plainPassword.equals(storedPassword);
    }

    public static boolean isHashed(String storedPassword) {
        return storedPassword != null
                && (storedPassword.startsWith("$2a$")
                        || storedPassword.startsWith("$2b$"));
    }
}
