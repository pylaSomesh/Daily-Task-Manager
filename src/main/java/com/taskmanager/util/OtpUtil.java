package com.taskmanager.util;

import java.security.SecureRandom;
import java.time.LocalDateTime;

public final class OtpUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    private OtpUtil() {
    }

    public static String generateOtp() {
        int value = RANDOM.nextInt(900000) + 100000;
        return String.valueOf(value);
    }

    public static LocalDateTime expiryTime(int minutes) {
        return LocalDateTime.now().plusMinutes(minutes);
    }

    public static boolean isExpired(LocalDateTime expiresAt) {
        return expiresAt == null || LocalDateTime.now().isAfter(expiresAt);
    }
}
