(function () {
    'use strict';

    module.exports = function (gulp, configuration) {

        gulp.task('build-sdk:admin', [
            'build-sdk:admin:javascripts',
            'build-sdk:admin:images',
            'build-sdk:admin:templates',
            'build-sdk:admin:bower'
        ]);

        gulp.task('build-sdk:admin-booking', [
            'build-sdk:admin-booking:javascripts',
            'build-sdk:admin-booking:stylesheets',
            'build-sdk:admin-booking:templates',
            'build-sdk:admin-booking:bower'
        ]);

        gulp.task('build-sdk:admin-dashboard', [
            'build-sdk:admin-dashboard:javascripts-core',
            'build-sdk:admin-dashboard:javascripts-lazy',
            'build-sdk:admin-dashboard:stylesheets',
            'build-sdk:admin-dashboard:images',
            'build-sdk:admin-dashboard:bower'
        ]);

        gulp.task('build-sdk:core', [
            'build-sdk:core:javascripts',
            'build-sdk:core:stylesheets',
            'build-sdk:core:templates',
            'build-sdk:core:bower'
        ]);

        gulp.task('build-sdk:events', [
            'build-sdk:events:javascripts',
            'build-sdk:events:templates',
            'build-sdk:events:bower'
        ]);

        gulp.task('build-sdk:member', [
            'build-sdk:member:javascripts',
            'build-sdk:member:stylesheets',
            'build-sdk:member:templates',
            'build-sdk:member:bower'
        ]);

        gulp.task('build-sdk:public-booking', [
            'build-sdk:public-booking:javascripts',
            'build-sdk:public-booking:stylesheets',
            'build-sdk:public-booking:fonts',
            'build-sdk:public-booking:images',
            'build-sdk:public-booking:templates',
            'build-sdk:public-booking:bower'
        ]);

        gulp.task('build-sdk:queue', [
            'build-sdk:queue:javascripts',
            'build-sdk:queue:templates',
            'build-sdk:queue:bower'
        ]);

        gulp.task('build-sdk:services', [
            'build-sdk:services:javascripts',
            'build-sdk:services:stylesheets',
            'build-sdk:services:templates',
            'build-sdk:services:bower'
        ]);

        gulp.task('build-sdk:settings', [
            'build-sdk:settings:javascripts',
            'build-sdk:settings:templates',
            'build-sdk:settings:bower'
        ]);

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
