/* Reusable toast notifications */
var Toast = (function () {
    var container = null;
    var icons = {
        success: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
        error: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>',
        warning: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>',
        info: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
    };

    function ensureContainer() {
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container';
            container.setAttribute('aria-live', 'polite');
            container.setAttribute('aria-atomic', 'true');
            document.body.appendChild(container);
        }
        return container;
    }

    function show(type, message, duration) {
        if (!message) return;

        var toastType = icons[type] ? type : 'info';
        var hold = typeof duration === 'number' ? duration : 5000;
        var root = ensureContainer();

        var toast = document.createElement('div');
        toast.className = 'toast toast-' + toastType;
        toast.setAttribute('role', toastType === 'error' ? 'alert' : 'status');
        toast.innerHTML =
            '<span class="toast-icon">' + icons[toastType] + '</span>' +
            '<span class="toast-message"></span>' +
            '<button type="button" class="toast-close" aria-label="Dismiss notification">&times;</button>';

        toast.querySelector('.toast-message').textContent = message;

        toast.querySelector('.toast-close').addEventListener('click', function () {
            dismiss(toast);
        });

        root.appendChild(toast);
        requestAnimationFrame(function () {
            toast.classList.add('toast-visible');
        });

        setTimeout(function () {
            dismiss(toast);
        }, hold);
    }

    function dismiss(toast) {
        if (!toast || toast.classList.contains('toast-hiding')) return;
        toast.classList.remove('toast-visible');
        toast.classList.add('toast-hiding');
        setTimeout(function () {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 320);
    }

    return {
        show: show,
        success: function (msg, duration) { show('success', msg, duration); },
        error: function (msg, duration) { show('error', msg, duration); },
        warning: function (msg, duration) { show('warning', msg, duration); },
        info: function (msg, duration) { show('info', msg, duration); }
    };
})();
