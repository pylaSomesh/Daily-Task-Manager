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
    <title>Daily Task Manager - Register</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/darkmode.css">
    <link rel="stylesheet" href="css/register.css">
</head>
<body<% if (toastType != null && toastMessage != null) { %>
    data-toast-type="<%= toastType %>"
    data-toast-message="<%= toastMessage.replace("\"", "&quot;") %>"<% } %>>

<div class="auth-topbar">
    <button type="button" id="theme-toggle" class="theme-toggle" aria-pressed="true">Light</button>
</div>

<div class="page-wrapper">
    <div class="brand">
        <div class="brand-icon">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>
        </div>
        <div class="brand-name">Daily Task Manager</div>
        <div class="brand-tagline">Stay organised. Stay ahead.</div>
    </div>
    <div class="top-left-home">
    <a href="index.jsp">← Home</a>
</div>

    <div class="card">
        <div class="card-heading">
            <h1>Create Your Account</h1>
            <p>Start managing your tasks efficiently today.</p>
        </div>

        <form class="form" id="registerForm" action="register" method="POST" onsubmit="return validateRegisterForm(this)">
            <div class="form-row">
                <div class="field">
                    <label for="username">Full Name</label>
                    <div class="input-wrap">
                        <input type="text" id="username" name="username" placeholder="Jane Doe"
                               autocomplete="name" required minlength="2" maxlength="80"
                               value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                    </div>
                    <span class="field-error" id="err-username" aria-live="polite"></span>
                </div>
                <div class="field">
                    <label for="email">Email Address</label>
                    <div class="input-wrap">
                        <input type="email" id="email" name="email" placeholder="you@example.com"
                               autocomplete="email" required maxlength="255"
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                    </div>
                    <span class="field-error" id="err-email" aria-live="polite"></span>
                </div>
            </div>

            <div class="field">
                <label for="password">Password</label>
                <div class="input-wrap has-toggle">
                    <input type="password" id="password" name="password" placeholder="Min. 8 characters"
                           autocomplete="new-password" required minlength="8" maxlength="128"
                           oninput="updateStrength(this.value)">
                    <button type="button" class="toggle-pw" aria-label="Show password"
                            onclick="toggleVisibility('password', this)">
                        <svg id="eye-pw" viewBox="0 0 24 24" aria-hidden="true"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                </div>
                <div class="strength-bar-wrap" aria-hidden="true">
                    <span class="strength-seg" id="seg-1"></span>
                    <span class="strength-seg" id="seg-2"></span>
                    <span class="strength-seg" id="seg-3"></span>
                    <span class="strength-seg" id="seg-4"></span>
                </div>
                <div class="strength-label" id="strength-label" aria-live="polite"></div>
                <span class="field-error" id="err-password" aria-live="polite"></span>
            </div>

            <div class="field">
                <label for="confirmPassword">Confirm Password</label>
                <div class="input-wrap has-toggle">
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat your password" autocomplete="new-password"
                           required minlength="8" maxlength="128">
                    <button type="button" class="toggle-pw" aria-label="Show confirm password"
                            onclick="toggleVisibility('confirmPassword', this)">
                        <svg id="eye-confirm" viewBox="0 0 24 24" aria-hidden="true"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                </div>
                <span class="field-error" id="err-confirm" aria-live="polite"></span>
            </div>

            <button type="submit" class="btn-register">Create Account</button>
        </form>

        <div class="divider"><span>Already have an account?</span></div>
        <div class="card-footer"><a href="login.jsp">Sign In</a></div>
    </div>

    <div class="page-footer">&copy; <%= java.time.Year.now().getValue() %> Daily Task Manager</div>
</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>
<script src="js/register.js"></script>
</body>
</html>
