<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.taskmanager.model.User" %>
<%@ page import="com.taskmanager.model.Task" %>
<%@ page import="com.taskmanager.util.ToastUtil" %>
<%@ page import="com.taskmanager.util.ProfileImageUtil" %>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

Task task = (Task) request.getAttribute("task");
if (task == null) {
    response.sendRedirect("DashboardServlet");
    return;
}

String username = user.getUsername();
String profileImagePath = ProfileImageUtil.getImagePath(user);
String profileInitial = ProfileImageUtil.getInitial(user);
String search = (String) request.getAttribute("search");
String statusFilter = (String) request.getAttribute("statusFilter");
String categoryFilter = (String) request.getAttribute("categoryFilter");

if (search == null) search = "";
if (statusFilter == null) statusFilter = "All";
if (categoryFilter == null) categoryFilter = "All";

String priority = task.getPriority();
if (priority == null || priority.trim().isEmpty()) priority = "Medium";

String category = task.getCategory();
if (category == null || category.trim().isEmpty()) category = "Personal";

String safeTitle = task.getTitle()
        .replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");

StringBuilder cancelQuery = new StringBuilder();
if (!search.trim().isEmpty()) {
    cancelQuery.append("search=").append(java.net.URLEncoder.encode(search.trim(), "UTF-8"));
}
if (!"All".equalsIgnoreCase(statusFilter)) {
    if (cancelQuery.length() > 0) cancelQuery.append("&");
    cancelQuery.append("statusFilter=").append(java.net.URLEncoder.encode(statusFilter, "UTF-8"));
}
if (!"All".equalsIgnoreCase(categoryFilter)) {
    if (cancelQuery.length() > 0) cancelQuery.append("&");
    cancelQuery.append("categoryFilter=").append(java.net.URLEncoder.encode(categoryFilter, "UTF-8"));
}
String cancelUrl = cancelQuery.length() > 0
        ? "DashboardServlet?" + cancelQuery.toString() : "DashboardServlet";

String toastType = (String) request.getAttribute("toastType");
String toastMessage = (String) request.getAttribute("toastMessage");
if (toastType == null) {
    toastType = (String) session.getAttribute(ToastUtil.TOAST_TYPE);
    toastMessage = (String) session.getAttribute(ToastUtil.TOAST_MESSAGE);
    if (toastType != null) {
        session.removeAttribute(ToastUtil.TOAST_TYPE);
        session.removeAttribute(ToastUtil.TOAST_MESSAGE);
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Task Manager – Edit Task</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/darkmode.css">
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body<% if (toastType != null && toastMessage != null) { %>
    data-toast-type="<%= toastType %>"
    data-toast-message="<%= toastMessage.replace("\"", "&quot;") %>"<% } %>>

<div class="layout">
    <nav class="navbar" role="banner">
        <a href="DashboardServlet" class="navbar-brand" aria-label="Daily Task Manager">
            <span class="navbar-title">Daily Task Manager</span>
        </a>
        <div class="navbar-right">
            <span class="navbar-greeting">Welcome, <strong><%= username %></strong></span>
            <% if (profileImagePath != null) { %>
            <img src="<%= profileImagePath %>" alt="Profile" class="avatar">
            <% } else { %>
            <div class="avatar-fallback" aria-hidden="true"><%= profileInitial %></div>
            <% } %>
            <button type="button" id="theme-toggle" class="theme-toggle" aria-pressed="true">Light</button>
            <a href="profile" class="btn-profile-link">Profile</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="content">
        <div class="page-header">
            <div class="page-header-text">
                <h2>Edit Task</h2>
                <p>Update task #<%= task.getId() %></p>
            </div>
        </div>

        <div class="edit-task-wrap">
            <div class="card">
                <div class="card-body">
                    <form class="add-form" action="updateTask" method="POST" onsubmit="return validateEditForm(this)">
                        <input type="hidden" name="id" value="<%= task.getId() %>">
                        <input type="hidden" name="search" value="<%= search.replace("\"", "&quot;") %>">
                        <input type="hidden" name="statusFilter" value="<%= statusFilter %>">
                        <input type="hidden" name="categoryFilter" value="<%= categoryFilter %>">

                        <div class="field">
                            <label for="title">Task Title <span class="required">*</span></label>
                            <input type="text" id="title" name="title" class="form-control"
                                   value="<%= safeTitle %>" required maxlength="200">
                        </div>
                        <div class="field">
                            <label for="dueDate">Due Date <span class="required">*</span></label>
                            <input type="date" id="dueDate" name="dueDate" class="form-control"
                                   value="<%= task.getDueDate() != null ? task.getDueDate() : "" %>" required>
                        </div>
                        <div class="field">
                            <label for="priority">Priority <span class="required">*</span></label>
                            <select id="priority" name="priority" class="form-control" required>
                                <option value="High" <%= "High".equalsIgnoreCase(priority) ? "selected" : "" %>>High</option>
                                <option value="Medium" <%= "Medium".equalsIgnoreCase(priority) ? "selected" : "" %>>Medium</option>
                                <option value="Low" <%= "Low".equalsIgnoreCase(priority) ? "selected" : "" %>>Low</option>
                            </select>
                        </div>
                        <div class="field">
                            <label for="category">Category <span class="required">*</span></label>
                            <select id="category" name="category" class="form-control" required>
                                <option value="Work" <%= "Work".equalsIgnoreCase(category) ? "selected" : "" %>>Work</option>
                                <option value="Personal" <%= "Personal".equalsIgnoreCase(category) ? "selected" : "" %>>Personal</option>
                                <option value="Study" <%= "Study".equalsIgnoreCase(category) ? "selected" : "" %>>Study</option>
                                <option value="Health" <%= "Health".equalsIgnoreCase(category) ? "selected" : "" %>>Health</option>
                            </select>
                        </div>
                        <div class="edit-actions">
                            <button type="submit" class="btn-add">Save Changes</button>
                            <a href="<%= cancelUrl %>" class="btn-toolbar btn-toolbar-clear">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
<script src="js/dashboard.js"></script>
</body>
</html>
