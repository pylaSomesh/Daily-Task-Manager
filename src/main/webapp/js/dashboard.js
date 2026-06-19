/* ── Live date in page header ──────────────────────────── */
(function () {
    var el = document.getElementById('live-date');
    if (!el) return;
    var now  = new Date();
    var opts = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    el.textContent = now.toLocaleDateString(undefined, opts);
})();

/* ── Delete confirmation ────────────────────────────────── */
function confirmDelete(e, anchor) {
    if (!confirm('Are you sure you want to delete this task?\nThis action cannot be undone.')) {
        e.preventDefault();
        return false;
    }
    return true;
}

/* ── Add task form validation ───────────────────────────── */
function validateAddForm(form) {
    var title = form.title.value.trim();
    if (!title) {
        form.title.focus();
        form.title.style.borderColor = 'var(--rose)';
        form.title.style.boxShadow   = '0 0 0 3px var(--rose-dim)';
        setTimeout(function () {
            form.title.style.borderColor = '';
            form.title.style.boxShadow   = '';
        }, 1800);
        return false;
    }
    return true;
}

/* ── Auto-dismiss flash alerts after 5 s ────────────────── */
(function () {
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (el) {
        setTimeout(function () {
            el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            el.style.opacity    = '0';
            el.style.transform  = 'translateY(-8px)';
            setTimeout(function () { el.remove(); }, 520);
        }, 5000);
    });
})();
