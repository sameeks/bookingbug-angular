angular.module('BB').value('AppConfig', {
    appId: 'f6b16c23',
    appKey: 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
});

angular.module('BB').value('AirbrakeConfig', {
    projectId: '122836',
    projectKey: 'e6d6710b2cf00be965e8452d6a384d37',
    environment: window.location.hostname === 'localhost' ? 'development' : 'production'
});

if (window.use_no_conflict) {
    window.bbjq = $.noConflict();
    angular.module('BB').value('$bbug', jQuery.noConflict(true));
} else {
    angular.module('BB').value('$bbug', jQuery);
}

angular.module('BB').constant('UriTemplate', window.UriTemplate);

angular.module('BB').config(function ($locationProvider, $httpProvider, $provide, ie8HttpBackendProvider, uiGmapGoogleMapApiProvider) {
    'ngInject';

    let webkit;
    uiGmapGoogleMapApiProvider.configure({
        v: '3.20',
        libraries: 'weather,geometry,visualization'
    });

    $httpProvider.defaults.headers.common = {
        'App-Id': 'f6b16c23',
        'App-Key': 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
    };

    // this should not be enforced - but set per app for custom app that uses html paths
    // $locationProvider.html5Mode(false).hashPrefix('!')

    let int = str => parseInt(str, 10);

    let lowercase = function (string) {
        if (angular.isString(string)) {
            return string.toLowerCase();
        } else {
            return string;
        }
    };

    let msie = int((/msie (\d+)/.exec(lowercase(navigator.userAgent)) || [])[1]);
    if (isNaN(msie)) {
        msie = int((/trident\/.*; rv:(\d+)/.exec(lowercase(navigator.userAgent)) || [])[1]);
    }

    let regexp = /Safari\/([\d.]+)/;
    let result = regexp.exec(navigator.userAgent);
    if (result) {
        webkit = parseFloat(result[1]);
    }

    if ((msie && (msie <= 9)) || (webkit && (webkit < 537))) {
        $provide.provider({$httpBackend: ie8HttpBackendProvider});
    }

});

window.bookingbug = {
    logout(options) {
        if (!options) {
            options = {};
        }
        if (options.reload !== false) {
            options.reload = true;
        }
        let logout_opts = {
            app_id: 'f6b16c23',
            app_key: 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
        };
        if (options.root) {
            logout_opts.root = options.root;
        }
        angular.injector(['BB.Services', 'BB.Models', 'ng'])
            .get('LoginService').logout(logout_opts);
        if (options.reload) {
            return window.location.reload();
        }
    }
};

