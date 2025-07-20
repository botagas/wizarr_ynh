// YunoHost compatibility polyfills for Wizarr
// This file provides browser API polyfills for better compatibility

// Polyfill for requestIdleCallback (used by HTMX)
if (!window.requestIdleCallback) {
    window.requestIdleCallback = function(cb, options) {
        var start = Date.now();
        return setTimeout(function() {
            cb({
                didTimeout: false,
                timeRemaining: function() {
                    return Math.max(0, 50 - (Date.now() - start));
                }
            });
        }, 1);
    };
}

if (!window.cancelIdleCallback) {
    window.cancelIdleCallback = function(id) {
        clearTimeout(id);
    };
}

// HTMX Configuration for YunoHost reverse proxy compatibility
document.addEventListener('DOMContentLoaded', function() {
    if (typeof htmx !== 'undefined') {
        // Configure HTMX for better compatibility
        htmx.config.selfRequestsOnly = false;
        htmx.config.allowEval = true;
        htmx.config.useTemplateFragments = true;
        
        // Debug HTMX requests in development
        if (window.location.hostname === 'localhost' || window.location.hostname.includes('test')) {
            document.body.addEventListener('htmx:beforeRequest', function(evt) {
                console.log('HTMX request to:', evt.detail.pathInfo?.requestPath || evt.detail.requestConfig?.url);
            });
            
            document.body.addEventListener('htmx:responseError', function(evt) {
                console.error('HTMX response error:', evt.detail);
            });
        }
    }
});
