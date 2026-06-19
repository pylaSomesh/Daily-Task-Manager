<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Task Manager - Login</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

    <div class="page-wrapper">

        <!-- Brand -->
        <div class="brand">
            <div class="brand-icon">
                <!-- Checklist icon -->
                <svg viewBox="0 0 24 24">
                    <path d="M9 11l3 3L22 4"/>
                    <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>
                </svg>
            </div>
            <div class="brand-name">Daily Task Manager</div>
            <div class="brand-tagline">Stay organised. Stay ahead.</div>
        </div>

        <!-- Card -->
        <div class="card">

            <div class="card-heading">
                <h1>Welcome back</h1>
                <p>Sign in to your account to continue</p>
            </div>

            <%-- Error message (JSP EL) --%>
            <c:if test="${not empty errorMessage}">
            <div class="error-banner" role="alert" aria-live="polite">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                <span>${errorMessage}</span>
            </div>
            </c:if>

            <%-- Fallback for containers without JSTL — uses scriptlet --%>
            <c:if test="${not empty errorMessage}">
                <div class="error-banner" role="alert" aria-live="polite">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <form class="form" action="login" method="POST"
      onsubmit="return validateForm(this)">
                <!-- Email -->
                <div class="field">
                    <label for="email">Email address</label>
                    <div class="input-wrap">
                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            autocomplete="email"
                            required
                            maxlength="255"
                        >
                        <!-- Email icon (positioned inside wrapper via CSS) -->
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <rect x="2" y="4" width="20" height="16" rx="2"/>
                            <path d="M2 7l10 7 10-7"/>
                        </svg>
                    </div>
                </div>

                <!-- Password -->
                <div class="field">
                    <label for="password">Password</label>
                    <div class="input-wrap has-toggle">
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required
                            minlength="8"
                            maxlength="128"
                        >
                        <!-- Lock icon -->
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0110 0v4"/>
                        </svg>
                        <!-- Show/hide password toggle -->
                        <button type="button" class="toggle-pw"
                                aria-label="Toggle password visibility"
                                onclick="togglePassword()">
                            <svg id="eye-icon" viewBox="0 0 24 24" aria-hidden="true"
                                 fill="none" stroke="currentColor" stroke-width="2"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-login">Sign In</button>

            </form>

            <div class="divider"><span>New here?</span></div>

            <div class="card-footer">
                Don't have an account?&nbsp;
                <a href="register.jsp">Create one free</a>
            </div>

        </div><!-- /.card -->

        <div class="page-footer">
            &copy; 2026 Daily Task Manager
        </div>

    </div><!-- /.page-wrapper -->

    <script src="js/login.js"></script>

</body>
</html>
