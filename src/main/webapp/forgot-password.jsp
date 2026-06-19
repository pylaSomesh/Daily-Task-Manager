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
String email = request.getParameter("email");
if (email == null) email = (String) request.getAttribute("email");
if (email == null) email = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Task Manager – Forgot Password</title>
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
        <div class="brand-name">Daily Task Manager</div>
        <div class="brand-tagline">Reset your password securely</div>
    </div>

    <div class="card">
        <div class="card-heading">
            <h1>Forgot Password</h1>
            <p>Enter your email and we will send a 6-digit OTP.</p>
        </div>

        <form class="form" action="forgotPassword" method="POST">
            <div class="field">
                <label for="email">Email address</label>
                <div class="input-wrap">
                    <input type="email" id="email" name="email" placeholder="you@example.com"
                           value="<%= email.replace("\"", "&quot;") %>"
                           autocomplete="email" required maxlength="255">
                </div>
            </div>
            <button type="submit" class="btn-login">Send OTP</button>
        </form>

        <div class="auth-link-row">
            <a href="login.jsp">Back to Sign In</a>
        </div>
    </div>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
</body>
</html>
