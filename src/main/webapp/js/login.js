/* ── Password visibility toggle ──────────────────────── */
function togglePassword() {
    var input   = document.getElementById('password');
    var eyeIcon = document.getElementById('eye-icon');
    var showing = input.type === 'text';

    input.type = showing ? 'password' : 'text';

    eyeIcon.innerHTML = showing
        ? /* eye icon */
          '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>'
        : /* eye-off icon */
          '<path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94"/>' +
          '<path d="M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/>' +
          '<line x1="1" y1="1" x2="23" y2="23"/>';

    document.querySelector('.toggle-pw').setAttribute(
        'aria-label', showing ? 'Show password' : 'Hide password'
    );
}

/* ── Client-side validation ──────────────────────────── */
function validateForm(form) {
    var email    = form.email.value.trim();
    var password = form.password.value;
    var emailRx  = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!email || !emailRx.test(email)) {
        showInlineError(form.email, 'Please enter a valid email address.');
        return false;
    }

    if (!password || password.length < 6) {
        showInlineError(form.password, 'Password must be at least 6 characters.');
        return false;
    }

    return true;
}

function showInlineError(inputEl, message) {
    /* Remove any existing inline error for this field */
    var existing = inputEl.closest('.field').querySelector('.inline-error');
    if (existing) existing.remove();

    var err = document.createElement('span');
    err.className = 'inline-error';
    err.setAttribute('role', 'alert');
    err.style.cssText =
        'font-size:12.5px;color:#f85149;margin-top:2px;display:block;animation:none;';
    err.textContent = message;

    inputEl.closest('.input-wrap').after(err);
    inputEl.focus();

    /* Auto-remove on next input */
    inputEl.addEventListener('input', function handler() {
        err.remove();
        inputEl.removeEventListener('input', handler);
    });
}
