(function (angular) {

    angular.module('BB.analytics').provider('bbAnalyticsPiwik', BBAnalyticsPiwikProvider);

    function BBAnalyticsPiwikProvider($analyticsProvider, $windowProvider) {
        'ngInject';

        let options = {
            firstPageView: false,
            virtualPageViews: false,
            enableLinkTracking: true,
            trackPageView: false,
            siteId: 1,
            trackerUrl: "https://analytics.bookingbug.com/piwik.php",
            scriptUrl: "https://analytics.bookingbug.com/piwik.js"
        };

        let $window = $windowProvider.$get();
        let enabled = false;

        this.isEnabled = function () {
            return enabled;
        };
        this.push = function (data) {
            if (!this.isEnabled()) return;
            // ---------------------------------------------------------------
            // we need to do this because the _paq object is not immediately
            // available after Piwik script is loaded
            // ---------------------------------------------------------------
            let _paq = [];
            if (!$window._paq) {
                $window._paq = _paq;
            } else {
                _paq = $window._paq;
            }
            _paq.push(data);
        };

        this.setOption = function (option, value) {
            if (!options.hasOwnProperty(option)) return;
            options[option] = value;

        };

        this.getOption = function (option) {
            if (!options.hasOwnProperty(option)) return null;
            return options[option];

        };

        this.enable = () => {
            enabled = true;

            $analyticsProvider.virtualPageviews(options.virtualPageViews);
            $analyticsProvider.firstPageview(options.firstPageView);

            if (options.trackPageView) this.push(['trackPageView']);
            if (options.enableLinkTracking) this.push(['enableLinkTracking']);

            this.push(['setTrackerUrl', options.trackerUrl]);
            this.push(['setSiteId', options.siteId]);

            let piwikScript = $window.document.createElement('script');
            piwikScript.type = 'text/javascript';
            piwikScript.async = true;
            piwikScript.defer = true;
            piwikScript.src = options.scriptUrl;

            let firstScript = $window.document.getElementsByTagName('script')[0];
            firstScript.parentNode.insertBefore(piwikScript, firstScript);
        };

        this.$get = () => {
            return {
                getOption: this.getOption,
                isEnabled: this.isEnabled,
                push: this.push
            };
        };
    }

})(angular);
