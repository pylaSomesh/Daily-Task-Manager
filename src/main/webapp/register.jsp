<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Task Manager - Register</title>
    <link rel="stylesheet" href="css/register.css">
</head>
<body>

<div class="page-wrapper">

    <!-- ── Brand ────────────────────────────────────────────── -->
    <div class="brand">
        <div class="brand-icon">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M9 11l3 3L22 4"/>
                <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>
            </svg>
        </div>
        <div class="brand-name">Daily Task Manager</div>
        <div class="brand-tagline">Stay organised. Stay ahead.</div>
    </div>

    <!-- ── Card ─────────────────────────────────────────────── -->
    <div class="card">

        <div class="card-heading">
            <h1>Create Your Account</h1>
            <p>Start managing your tasks efficiently today.</p>
        </div>

        <%-- ── Server-side messages (scriptlet, no JSTL required) ── --%>
        <%
            String errorMessage   = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");

            if (errorMessage != null && !errorMessage.trim().isEmpty()) {
        %>
        <div class="alert alert-error" role="alert" aria-live="polite">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8"  x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            <span><%= errorMessage %></span>
        </div>
        <% } %>

        <%
            if (successMessage != null && !successMessage.trim().isEmpty()) {
        %>
        <div class="alert alert-success" role="status" aria-live="polite">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M22 11.08V12a10 10 0 11-5.93-9.14"/>
                <polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            <span><%= successMessage %></span>
        </div>
        <% } %>

        <form class="form"
      id="registerForm"
      action="register"
      method="POST"
      onsubmit="return validateRegisterForm(this)">

            <!-- Row: Full Name + Email -->
            <div class="form-row">

                <!-- Full Name -->
                <div class="field">
                    <label for="username">Full Name</label>
                    <div class="input-wrap">
                        <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Jane Doe"
                        autocomplete="name"
                        required
                        minlength="2"
                        maxlength="80"
                        value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                    >
                        <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                    </div>
                    <span class="field-error" id="err-username" aria-live="polite"></span>
                </div>

                <!-- Email -->
                <div class="field">
                    <label for="email">Email Address</label>
                    <div class="input-wrap">
                        <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="you@example.com"
                        autocomplete="email"
                        required
                        maxlength="255"
                        value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                    >
                        <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect x="2" y="4" width="20" height="16" rx="2"/>
                            <path d="M2 7l10 7 10-7"/>
                        </svg>
                    </div>
                    <span class="field-error" id="err-email" aria-live="polite"></span>
                </div>

            </div><!-- /.form-row -->

            <!-- Password -->
            <div class="field">
                <label for="password">Password</label>
                <div class="input-wrap has-toggle">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Min. 8 characters"
                        autocomplete="new-password"
                        required
                        minlength="8"
                        maxlength="128"
                        oninput="updateStrength(this.value)"
                    >
                    <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0110 0v4"/>
                    </svg>
                    <button type="button" class="toggle-pw"
                            aria-label="Show password"
                            onclick="toggleVisibility('password', this)">
                        <svg id="eye-pw" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <!-- Strength indicator -->
                <div class="strength-bar-wrap" aria-hidden="true">
                    <span class="strength-seg" id="seg-1"></span>
                    <span class="strength-seg" id="seg-2"></span>
                    <span class="strength-seg" id="seg-3"></span>
                    <span class="strength-seg" id="seg-4"></span>
                </div>
                <div class="strength-label" id="strength-label" aria-live="polite"></div>
                <span class="field-error" id="err-password" aria-live="polite"></span>
            </div>

            <!-- Confirm Password -->
            <div class="field">
                <label for="confirmPassword">Confirm Password</label>
                <div class="input-wrap has-toggle">
                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Repeat your password"
                        autocomplete="new-password"
                        required
                        minlength="8"
                        maxlength="128"
                    >
                    <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                    <button type="button" class="toggle-pw"
                            aria-label="Show confirm password"
                            onclick="toggleVisibility('confirmPassword', this)">
                        <svg id="eye-confirm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <span class="field-error" id="err-confirm" aria-live="polite"></span>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn-register">
                Create Account
            </button>

        </form>

        <div class="divider"><span>Already have an account?</span></div>

        <div class="card-footer">
            <a href="login.jsp">Sign In</a>
        </div>

    </div><!-- /.card -->

    <div class="page-footer">
        &copy; <%= java.time.Year.now().getValue() %> Daily Task Manager
    </div>

</div><!-- /.page-wrapper -->

<script src="js/register.js"></script>

</body>
</html>
