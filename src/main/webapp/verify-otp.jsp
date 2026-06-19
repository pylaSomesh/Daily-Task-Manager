<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.taskmanager.util.ToastUtil" %>
<%@ page import="com.taskmanager.util.MailConfig" %>

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

String resetEmail =
        (String) request.getAttribute("resetEmail");

if (resetEmail == null) {
    resetEmail =
            (String) session.getAttribute("resetEmail");
}

String demoOtp =
        (String) session.getAttribute("demoOtp");

int expiryMinutes =
        MailConfig.getOtpExpiryMinutes();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Daily Task Manager – Verify OTP</title>

    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/darkmode.css">
    <link rel="stylesheet" href="css/login.css">
</head>

<body
<% if (toastType != null && toastMessage != null) { %>
    data-toast-type="<%= toastType %>"
    data-toast-message="<%= toastMessage.replace("\"", "&quot;") %>"
<% } %>
>

<div class="auth-topbar">
    <button type="button"
            id="theme-toggle"
            class="theme-toggle"
            aria-pressed="true">
        Light
    </button>
</div>

<div class="page-wrapper">

    <div class="card">

        <div class="card-heading">

            <h1>Verify OTP</h1>

            <p>
                Enter the 6-digit code sent to
                <strong><%= resetEmail %></strong>.
            </p>

            <p style="
                    font-size:13px;
                    color:var(--text-secondary,#8b949e);
                    margin-top:8px;">

                OTP expires in
                <%= expiryMinutes %> minutes.
            </p>

            <% if (demoOtp != null) { %>

                <div style="
                        margin-top:15px;
                        padding:12px;
                        border-radius:8px;
                        background:#d4edda;
                        color:#155724;
                        font-weight:bold;
                        text-align:center;">

                        OTP:
                    <%= demoOtp %>

                </div>

            <% } %>

        </div>

        <form class="form"
              action="verifyOtp"
              method="POST">

            <div class="field">

                <label for="otp">
                    One-Time Password
                </label>

                <div class="input-wrap">

                    <input type="text"
                           id="otp"
                           name="otp"
                           placeholder="123456"
                           pattern="[0-9]{6}"
                           maxlength="6"
                           inputmode="numeric"
                           autocomplete="one-time-code"
                           required>

                </div>

            </div>

            <button type="submit"
                    class="btn-login">

                Verify OTP

            </button>

        </form>

        <form class="form"
              action="resendOtp"
              method="POST"
              style="margin-top:12px;">

            <button type="submit"
                    class="btn-login"
                    style="
                        background:var(--bg-card,#1c2330);
                        color:var(--text-primary,#e6edf3);
                        box-shadow:none;
                        border:1px solid var(--border,#30363d);">

                Resend OTP

            </button>

        </form>

        <div class="auth-link-row">
            <a href="forgotPassword">
                Change email
            </a>
        </div>

    </div>

</div>

<script src="js/toast.js"></script>
<script src="js/darkmode.js"></script>
<script src="js/common.js"></script>

</body>
</html>
