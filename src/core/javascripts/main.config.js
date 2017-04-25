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

angular.module('BB').config(function ($locationProvider, $httpProvider, $provide, uiGmapGoogleMapApiProvider, $analyticsProvider) {
    'ngInject';

    uiGmapGoogleMapApiProvider.configure({
        v: '3.20',
        libraries: 'weather,geometry,visualization'
    });

    $httpProvider.defaults.headers.common = {
        'App-Id': 'f6b16c23',
        'App-Key': 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
    };
});

window.bookingbug = { //TODO remove
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

window.getURIparam = function (name) {  //TODO remove
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results == null)
        return "";
    else
        return results[1];
};

