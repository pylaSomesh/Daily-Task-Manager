/* Theme toggle – persists in localStorage */
var DarkMode = (function () {
    var STORAGE_KEY = 'dtm-theme';
    var toggleBtn = null;

    function getPreferredTheme() {
        var stored = localStorage.getItem(STORAGE_KEY);
        if (stored === 'light' || stored === 'dark') {
            return stored;
        }
        return 'dark';
    }

    function applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem(STORAGE_KEY, theme);
        updateToggleLabel(theme);
    }

    function updateToggleLabel(theme) {
        if (!toggleBtn) return;
        var isDark = theme === 'dark';
        toggleBtn.setAttribute('aria-pressed', isDark ? 'true' : 'false');
        toggleBtn.setAttribute('aria-label', isDark ? 'Switch to light mode' : 'Switch to dark mode');
        toggleBtn.title = isDark ? 'Light mode' : 'Dark mode';
        toggleBtn.textContent = isDark ? 'Light' : 'Dark';
    }

    function toggle() {
        var current = document.documentElement.getAttribute('data-theme') || 'dark';
        applyTheme(current === 'dark' ? 'light' : 'dark');
    }

    function init() {
        applyTheme(getPreferredTheme());
        toggleBtn = document.getElementById('theme-toggle');
        if (toggleBtn) {
            toggleBtn.addEventListener('click', toggle);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    return { toggle: toggle, applyTheme: applyTheme };
})();
