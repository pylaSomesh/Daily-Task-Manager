<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.taskmanager.util.ToastUtil" %>
<%
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
    <title>Daily Task Manager - Login</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/darkmode.css">
    <link rel="stylesheet" href="css/login.css">
</head>
<body<% if (toastType != null && toastMessage != null) { %>
    data-toast-type="<%= toastType %>"
    data-toast-message="<%= toastMessage.replace("\"", "&quot;") %>"<% } %>>

<div class="auth-topbar">
    <button type="button" id="theme-toggle" class="theme-toggle" aria-pressed="true">Light</button>
</div>
<div class="top-left-home">
    <a href="index.jsp">← Home</a>
</div>

<div class="page-wrapper">
    <div class="brand">
        <div class="brand-icon">
            <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>
        </div>
        <div class="brand-name">Daily Task Manager</div>
        <div class="brand-tagline">Stay organised. Stay ahead.</div>
    </div>

    <div class="card">
        <div class="card-heading">
            <h1>Welcome back</h1>
            <p>Sign in to your account to continue</p>
        </div>

        <form class="form" action="login" method="POST" onsubmit="return validateForm(this)">
            <div class="field">
                <label for="email">Email address</label>
                <div class="input-wrap">
                    <input type="email" id="email" name="email" placeholder="you@example.com"
                           autocomplete="email" required maxlength="255">
                    <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="M2 7l10 7 10-7"/></svg>
                </div>
            </div>
            <div class="field">
                <label for="password">Password</label>
                <div class="input-wrap has-toggle">
                    <input type="password" id="password" name="password" placeholder="Enter your password"
                           autocomplete="current-password" required minlength="8" maxlength="128">
                    <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                    <button type="button" class="toggle-pw" aria-label="Toggle password visibility" onclick="togglePassword()">
                        <svg id="eye-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
            </div>
            <button type="submit" class="btn-login">Sign In</button>
        </form>

        <div class="auth-link-row">
            <a href="forgotPassword">Forgot Password?</a>
        </div>

        <div class="divider"><span>New here?</span></div>
        <div class="card-footer">
            Don't have an account?&nbsp;<a href="register.jsp">Create one free</a>
        </div>
    </div>

    <div class="page-footer">&copy; <%= java.time.Year.now().getValue() %> Daily Task Manager</div>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
<script src="js/login.js"></script>
</body>
</html>
