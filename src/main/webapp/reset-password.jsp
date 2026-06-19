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
    <title>Daily Task Manager – Reset Password</title>
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
    <div class="card">
        <div class="card-heading">
            <h1>Reset Password</h1>
            <p>Create a new password for your account.</p>
        </div>

        <form class="form" action="resetPassword" method="POST" onsubmit="return validateResetForm(this)">
            <div class="field">
                <label for="newPassword">New Password</label>
                <div class="input-wrap">
                    <input type="password" id="newPassword" name="newPassword"
                           placeholder="Min. 8 characters" minlength="8" maxlength="128"
                           autocomplete="new-password" required>
                </div>
            </div>
            <div class="field">
                <label for="confirmPassword">Confirm Password</label>
                <div class="input-wrap">
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat password" minlength="8" maxlength="128"
                           autocomplete="new-password" required>
                </div>
            </div>
            <button type="submit" class="btn-login">Reset Password</button>
        </form>

        <div class="auth-link-row">
            <a href="login.jsp">Back to Sign In</a>
        </div>
    </div>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
<script>
function validateResetForm(form) {
    if (form.newPassword.value !== form.confirmPassword.value) {
        if (window.Toast) Toast.error('Passwords do not match.');
        return false;
    }
    return true;
}
</script>
</body>
</html>
