/* Shared page helpers */
(function () {
    function readPageToast() {
        var body = document.body;
        if (!body) return;

        var type = body.getAttribute('data-toast-type');
        var message = body.getAttribute('data-toast-message');

        if (type && message && window.Toast) {
            Toast.show(type, message);
            body.removeAttribute('data-toast-type');
            body.removeAttribute('data-toast-message');
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', readPageToast);
    } else {
        readPageToast();
    }
})();
