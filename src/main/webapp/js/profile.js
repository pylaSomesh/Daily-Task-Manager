function validateProfileForm(form) {
    var username = form.username.value.trim();
    var email = form.email.value.trim();
    var newPassword = form.newPassword.value;
    var confirmPassword = form.confirmPassword.value;
    var currentPassword = form.currentPassword.value;

    if (!username || !email) {
        if (window.Toast) Toast.error('Username and email are required.');
        return false;
    }

    if (newPassword || confirmPassword || currentPassword) {
        if (!currentPassword) {
            if (window.Toast) Toast.error('Enter your current password to change it.');
            form.currentPassword.focus();
            return false;
        }
        if (newPassword.length < 8) {
            if (window.Toast) Toast.error('New password must be at least 8 characters.');
            form.newPassword.focus();
            return false;
        }
        if (newPassword !== confirmPassword) {
            if (window.Toast) Toast.error('New passwords do not match.');
            form.confirmPassword.focus();
            return false;
        }
    }

    return true;
}

function toggleProfilePassword(fieldId, button) {
    var field = document.getElementById(fieldId);
    if (!field) return;
    var isPassword = field.type === 'password';
    field.type = isPassword ? 'text' : 'password';
    button.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
}
