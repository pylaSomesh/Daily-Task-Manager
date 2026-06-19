<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.taskmanager.model.User" %>
<%@ page import="com.taskmanager.util.ToastUtil" %>
<%@ page import="com.taskmanager.util.ProfileImageUtil" %>

<%
User sessionUser = (User) session.getAttribute("user");
if (sessionUser == null) {
    response.sendRedirect("login.jsp");
    return;
}

User profileUser = (User) request.getAttribute("profileUser");
if (profileUser == null) {
    response.sendRedirect("profile");
    return;
}

String username = sessionUser.getUsername();
String profileImagePath = ProfileImageUtil.getImagePath(profileUser);
String profileInitial = ProfileImageUtil.getInitial(profileUser);

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

String safeUsername = profileUser.getUsername() != null
        ? profileUser.getUsername().replace("\"", "&quot;") : "";
String safeEmail = profileUser.getEmail() != null
        ? profileUser.getEmail().replace("\"", "&quot;") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Task Manager – Profile</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/darkmode.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/profile.css">
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
            <a href="DashboardServlet" class="btn-profile-link">Dashboard</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </nav>

    <div class="content">
        <div class="page-header">
            <div class="page-header-user">
                <% if (profileImagePath != null) { %>
                <img src="<%= profileImagePath %>" alt="Profile picture" class="avatar-lg">
                <% } else { %>
                <div class="avatar-fallback avatar-fallback-lg" aria-hidden="true"><%= profileInitial %></div>
                <% } %>
                <div class="page-header-user-info">
                    <h2>My Profile</h2>
                    <p>View and update your account details.</p>
                </div>
            </div>
        </div>

        <div class="profile-wrap">
            <div class="card">
                <div class="card-head">
                    <div class="card-head-left">
                        <div><h3>Profile Picture</h3><p>JPG, PNG, GIF, WEBP — max 2MB</p></div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="profile-picture-section">
                        <% if (profileImagePath != null) { %>
                        <img src="<%= profileImagePath %>" alt="Current profile picture" class="avatar-lg">
                        <% } else { %>
                        <div class="avatar-fallback avatar-fallback-lg"><%= profileInitial %></div>
                        <% } %>
                        <div class="profile-picture-meta">
                            <h4><%= safeUsername %></h4>
                            <p><%= safeEmail %></p>
                            <form class="profile-upload-form" action="uploadProfilePicture"
                                  method="POST" enctype="multipart/form-data">
                                <input type="file" id="profileImage" name="profileImage"
                                       accept="image/jpeg,image/png,image/gif,image/webp" required>
                                <button type="submit" class="btn-toolbar">Upload / Change Picture</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" style="margin-top:18px;">
                <div class="card-head"><div class="card-head-left"><div><h3>Account Settings</h3></div></div></div>
                <div class="card-body">
                    <form class="profile-form" action="updateProfile" method="POST"
                          onsubmit="return validateProfileForm(this)">
                        <div class="field">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-control"
                                   required maxlength="80" value="<%= safeUsername %>" autocomplete="username">
                        </div>
                        <div class="field">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   required maxlength="255" value="<%= safeEmail %>" autocomplete="email">
                        </div>
                        <div class="profile-section-title">Change Password (optional)</div>
                        <div class="field">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword"
                                   class="form-control" autocomplete="current-password">
                        </div>
                        <div class="field">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword"
                                   class="form-control" minlength="8" autocomplete="new-password">
                        </div>
                        <div class="field">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   class="form-control" minlength="8" autocomplete="new-password">
                        </div>
                        <div class="profile-actions">
                            <button type="submit" class="btn-add">Save Profile</button>
                            <a href="DashboardServlet" class="btn-toolbar btn-toolbar-clear">Cancel</a>
                        </div>
                    </form>

                    <div class="profile-forgot-wrap">
                        <p>Forgot your password? We will send an OTP to your registered email.</p>
                        <form action="sendProfileOtp" method="POST">
                            <button type="submit" class="btn-toolbar">Forgot Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer role="contentinfo">
        <span class="footer-copy">&copy; <%= java.time.Year.now().getValue() %> Daily Task Manager</span>
    </footer>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
<script src="js/profile.js"></script>
</body>
</html>
