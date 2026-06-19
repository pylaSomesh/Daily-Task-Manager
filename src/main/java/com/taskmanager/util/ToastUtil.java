package com.taskmanager.util;

import java.io.IOException;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public final class ToastUtil {

    public static final String TOAST_TYPE = "toastType";
    public static final String TOAST_MESSAGE = "toastMessage";

    private ToastUtil() {
    }

    public static void flash(HttpSession session, String type, String message) {
        session.setAttribute(TOAST_TYPE, type);
        session.setAttribute(TOAST_MESSAGE, message);
    }

    public static void flashRedirect(HttpServletResponse response,
            HttpSession session,
            String url,
            String type,
            String message) throws IOException {
        flash(session, type, message);
        response.sendRedirect(url);
    }
}
