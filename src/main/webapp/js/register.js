/* ── Password visibility toggle ───────────────────────────── */
var EYE_OPEN = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
var EYE_OFF  = '<path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94"/>' +
               '<path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/>' +
               '<line x1="1" y1="1" x2="23" y2="23"/>';

function toggleVisibility(inputId, btn) {
    var input = document.getElementById(inputId);
    var svg   = btn.querySelector('svg');
    var showing = input.type === 'text';
    input.type  = showing ? 'password' : 'text';
    svg.innerHTML = showing ? EYE_OPEN : EYE_OFF;
    btn.setAttribute('aria-label', showing ? 'Show password' : 'Hide password');
}

/* ── Password strength meter ───────────────────────────────── */
var STRENGTH_COLORS = ['', '#f85149', '#f0a832', '#4a90d9', '#3fb950'];
var STRENGTH_LABELS = ['', 'Weak', 'Fair', 'Good', 'Strong'];

function updateStrength(val) {
    var score = 0;
    if (val.length >= 8)  score++;
    if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
    if (/\d/.test(val))   score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    for (var i = 1; i <= 4; i++) {
        var seg = document.getElementById('seg-' + i);
        seg.style.background = i <= score ? STRENGTH_COLORS[score] : 'var(--border)';
    }

    var label = document.getElementById('strength-label');
    label.textContent = val.length > 0 ? 'Strength: ' + STRENGTH_LABELS[score] : '';
    label.style.color  = STRENGTH_COLORS[score] || 'var(--tx-3)';
}

/* ── Client-side form validation ───────────────────────────── */
function setErr(id, msg) {
    var el = document.getElementById(id);
    el.textContent = msg;
    el.classList.toggle('show', !!msg);
}

function clearErr(id) { setErr(id, ''); }

function validateRegisterForm(form) {
    var ok = true;

    // Full name
    var name = form.username.value.trim();
    if (!name || name.length < 2) {
        setErr('err-username', 'Please enter your full name (min. 2 characters).');
        ok = false;
    } else { clearErr('err-username'); }

    // Email
    var email   = form.email.value.trim();
    var emailRx = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !emailRx.test(email)) {
        setErr('err-email', 'Please enter a valid email address.');
        ok = false;
    } else { clearErr('err-email'); }

    // Password
    var pw = form.password.value;
    if (!pw || pw.length < 8) {
        setErr('err-password', 'Password must be at least 8 characters.');
        ok = false;
    } else { clearErr('err-password'); }

    // Confirm password
    var cpw = form.confirmPassword.value;
    if (!cpw) {
        setErr('err-confirm', 'Please confirm your password.');
        ok = false;
    } else if (pw !== cpw) {
        setErr('err-confirm', 'Passwords do not match. Please try again.');
        ok = false;
    } else { clearErr('err-confirm'); }

    if (!ok) {
        // Focus first errored field
        var firstErr = form.querySelector('.field-error.show');
        if (firstErr) {
            var field = firstErr.closest('.field');
            if (field) {
                var input = field.querySelector('input');
                if (input) input.focus();
            }
        }
    }

    return ok;
}

/* ── Clear inline errors on user input ────────────────────── */
(function () {
    var pairs = [
        ['username',        'err-username'],
        ['email',           'err-email'],
        ['password',        'err-password'],
        ['confirmPassword', 'err-confirm']
    ];
    pairs.forEach(function (pair) {
        var input = document.getElementById(pair[0]);
        if (input) {
            input.addEventListener('input', function () { clearErr(pair[1]); });
        }
    });
})();
