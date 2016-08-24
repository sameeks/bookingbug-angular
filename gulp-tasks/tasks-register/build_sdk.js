(function () {
    'use strict';

    module.exports = function (gulp, configuration) {

        gulp.task('build-sdk', [
            'build-sdk:core',
            'build-sdk:public-booking',
            'build-sdk:member',
            'build-sdk:admin',
            'build-sdk:admin-booking',
            'build-sdk:admin-dashboard',
            'build-sdk:events',
            'build-sdk:services',
            'build-sdk:settings'
        ]);
    };

}).call(this);
