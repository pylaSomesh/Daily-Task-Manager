package com.taskmanager.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public final class FilterQueryUtil {

    private FilterQueryUtil() {
    }

    public static String build(String search,
            String statusFilter,
            String categoryFilter) {

        StringBuilder query = new StringBuilder();

        appendParam(query, "search", search);

        if (statusFilter != null
                && !statusFilter.trim().isEmpty()
                && !"All".equalsIgnoreCase(statusFilter.trim())) {
            appendParam(query, "statusFilter", statusFilter.trim());
        }

        if (categoryFilter != null
                && !categoryFilter.trim().isEmpty()
                && !"All".equalsIgnoreCase(categoryFilter.trim())) {
            appendParam(query, "categoryFilter", categoryFilter.trim());
        }

        return query.toString();
    }

    private static void appendParam(StringBuilder query,
            String name,
            String value) {

        if (value == null || value.trim().isEmpty()) {
            return;
        }

        if (query.length() > 0) {
            query.append("&");
        }

        query.append(name)
             .append("=")
             .append(URLEncoder.encode(value.trim(), StandardCharsets.UTF_8));
    }
}
