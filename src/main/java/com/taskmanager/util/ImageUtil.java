package com.taskmanager.util;

import java.util.Set;

import jakarta.servlet.http.Part;

public final class ImageUtil {

    public static final long MAX_SIZE_BYTES = 2L * 1024 * 1024;

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/png",
            "image/gif",
            "image/webp");

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(
            ".jpg", ".jpeg", ".png", ".gif", ".webp");

    private ImageUtil() {
    }

    public static boolean isValidImage(Part filePart, String submittedFileName) {
        if (filePart == null || submittedFileName == null || submittedFileName.isBlank()) {
            return false;
        }

        if (filePart.getSize() <= 0 || filePart.getSize() > MAX_SIZE_BYTES) {
            return false;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            return false;
        }

        String lowerName = submittedFileName.toLowerCase();
        boolean validExtension = false;
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerName.endsWith(ext)) {
                validExtension = true;
                break;
            }
        }

        return validExtension;
    }

    public static String resolveExtension(String submittedFileName, String contentType) {
        if (submittedFileName != null) {
            String lower = submittedFileName.toLowerCase();
            if (lower.endsWith(".png")) return ".png";
            if (lower.endsWith(".gif")) return ".gif";
            if (lower.endsWith(".webp")) return ".webp";
            if (lower.endsWith(".jpeg")) return ".jpeg";
            if (lower.endsWith(".jpg")) return ".jpg";
        }
        if ("image/png".equalsIgnoreCase(contentType)) return ".png";
        if ("image/gif".equalsIgnoreCase(contentType)) return ".gif";
        if ("image/webp".equalsIgnoreCase(contentType)) return ".webp";
        return ".jpg";
    }
}
