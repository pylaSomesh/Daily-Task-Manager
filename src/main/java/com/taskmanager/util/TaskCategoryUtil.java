package com.taskmanager.util;

import java.util.Set;

public final class TaskCategoryUtil {

    public static final String DEFAULT = "Personal";

    private static final Set<String> ALLOWED = Set.of(
            "Work", "Personal", "Study", "Health");

    private TaskCategoryUtil() {
    }

    public static boolean isValid(String category) {
        return category != null && ALLOWED.contains(category);
    }

    public static String normalize(String category) {
        if (isValid(category)) {
            return category;
        }
        return DEFAULT;
    }
}
