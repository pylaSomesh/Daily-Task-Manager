package com.taskmanager.util;

import com.taskmanager.model.User;

public final class ProfileImageUtil {

    private ProfileImageUtil() {
    }

    public static boolean hasImage(User user) {
        return user != null
                && user.getProfileImage() != null
                && !user.getProfileImage().trim().isEmpty();
    }

    public static String getImagePath(User user) {
        if (!hasImage(user)) {
            return null;
        }
        return user.getProfileImage().trim();
    }

    public static String getInitial(User user) {
        if (user == null || user.getUsername() == null || user.getUsername().isEmpty()) {
            return "U";
        }
        return user.getUsername().substring(0, 1).toUpperCase();
    }
}
