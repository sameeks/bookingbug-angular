(function () {
    'use strict';

    const assets = require('../helpers/assets.js');

    module.exports = function (gulp, configuration) {

        assets.overrideRootPath(configuration.rootPath);

        gulp.task('build-sdk:admin:javascripts', function (done) {
            assets.javascripts(done, 'admin');
        });

        gulp.task('build-sdk:admin:stylesheets', function (done) {
            assets.stylesheets(done, 'admin');
        });

        gulp.task('build-sdk:admin:images', function (done) {
            assets.images(done, 'admin');
        });

        gulp.task('build-sdk:admin:fonts', function (done) {
            assets.fonts(done, 'admin');
        });

        gulp.task('build-sdk:admin:templates', function (done) {
            assets.templates(done, 'admin');
        });

        gulp.task('build-sdk:admin:bower', function (done) {
            assets.bower(done, 'admin');
        });

        gulp.task('build-sdk:admin', [
            'build-sdk:admin:javascripts',
            'build-sdk:admin:templates',
            'build-sdk:admin:stylesheets',
            'build-sdk:admin:images',
            'build-sdk:admin:fonts',
            'build-sdk:admin:bower'
        ]);

        gulp.task('build-sdk:admin-booking:javascripts', function (done) {
            assets.javascripts(done, 'admin-booking');
        });

        gulp.task('build-sdk:admin-booking:stylesheets', function (done) {
            assets.stylesheets(done, 'admin-booking');
        });

        gulp.task('build-sdk:admin-booking:templates', function (done) {
            assets.templates(done, 'admin-booking', 'BBAdminBooking');
        });

        gulp.task('build-sdk:admin-booking:images', function (done) {
            assets.images(done, 'admin-booking');
        });

        gulp.task('build-sdk:admin-booking:fonts', function (done) {
            assets.fonts(done, 'admin-booking');
        });

        gulp.task('build-sdk:admin-booking:bower', function (done) {
            assets.bower(done, 'admin-booking');
        });

        gulp.task('build-sdk:admin-booking', [
            'build-sdk:admin-booking:javascripts',
            'build-sdk:admin-booking:templates',
            'build-sdk:admin-booking:stylesheets',
            'build-sdk:admin-booking:images',
            'build-sdk:admin-booking:fonts',
            'build-sdk:admin-booking:bower'
        ]);

        gulp.task('build-sdk:admin-dashboard:javascripts', function (done) {
            assets.javascripts(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:stylesheets', function (done) {
            assets.stylesheets(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:images', function (done) {
            assets.images(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:templates', function (done) {
            assets.templates(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:fonts', function (done) {
            assets.fonts(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:bower', function (done) {
            assets.bower(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard', [
            'build-sdk:admin-dashboard:javascripts',
            'build-sdk:admin-dashboard:templates',
            'build-sdk:admin-dashboard:stylesheets',
            'build-sdk:admin-dashboard:images',
            'build-sdk:admin-dashboard:fonts',
            'build-sdk:admin-dashboard:bower'
        ]);

        gulp.task('build-sdk:core:javascripts', function (done) {
            assets.javascripts(done, 'core');
        });

        gulp.task('build-sdk:core:stylesheets', function (done) {
            assets.stylesheets(done, 'core');
        });

        gulp.task('build-sdk:core:templates', function (done) {
            assets.templates(done, 'core');
        });

        gulp.task('build-sdk:core:images', function (done) {
            assets.images(done, 'core');
        });

        gulp.task('build-sdk:core:fonts', function (done) {
            assets.fonts(done, 'core');
        });

        gulp.task('build-sdk:core:bower', function (done) {
            assets.bower(done, 'core');
        });

        gulp.task('build-sdk:core', [
            'build-sdk:core:javascripts',
            'build-sdk:core:templates',
            'build-sdk:core:stylesheets',
            'build-sdk:core:images',
            'build-sdk:core:fonts',
            'build-sdk:core:bower'
        ]);

        gulp.task('build-sdk:events:javascripts', function (done) {
            assets.javascripts(done, 'events');
        });

        gulp.task('build-sdk:events:stylesheets', function (done) {
            assets.stylesheets(done, 'events');
        });

        gulp.task('build-sdk:events:templates', function (done) {
            assets.templates(done, 'events');
        });

        gulp.task('build-sdk:events:images', function (done) {
            assets.images(done, 'events');
        });

        gulp.task('build-sdk:events:fonts', function (done) {
            assets.fonts(done, 'events');
        });

        gulp.task('build-sdk:events:bower', function (done) {
            assets.bower(done, 'events');
        });

        gulp.task('build-sdk:events', [
            'build-sdk:events:javascripts',
            'build-sdk:events:templates',
            'build-sdk:events:stylesheets',
            'build-sdk:events:images',
            'build-sdk:events:fonts',
            'build-sdk:events:bower'
        ]);

        gulp.task('build-sdk:member:javascripts', function (done) {
            assets.javascripts(done, 'member');
        });

        gulp.task('build-sdk:member:stylesheets', function (done) {
            assets.stylesheets(done, 'member');
        });

        gulp.task('build-sdk:member:templates', function (done) {
            assets.templates(done, 'member');
        });

        gulp.task('build-sdk:member:images', function (done) {
            assets.images(done, 'member');
        });

        gulp.task('build-sdk:member:fonts', function (done) {
            assets.fonts(done, 'member');
        });

        gulp.task('build-sdk:member:bower', function (done) {
            assets.bower(done, 'member');
        });

        gulp.task('build-sdk:member', [
            'build-sdk:member:javascripts',
            'build-sdk:member:templates',
            'build-sdk:member:stylesheets',
            'build-sdk:member:images',
            'build-sdk:member:fonts',
            'build-sdk:member:bower'
        ]);

        gulp.task('build-sdk:public-booking:javascripts', function (done) {
            assets.javascripts(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking:stylesheets', function (done) {
            assets.stylesheets(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking:fonts', function (done) {
            assets.fonts(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking:images', function (done) {
            assets.images(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking:templates', function (done) {
            assets.templates(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking:bower', function (done) {
            assets.bower(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking', [
            'build-sdk:public-booking:javascripts',
            'build-sdk:public-booking:templates',
            'build-sdk:public-booking:stylesheets',
            'build-sdk:public-booking:images',
            'build-sdk:public-booking:fonts',
            'build-sdk:public-booking:bower'
        ]);

        gulp.task('build-sdk:queue:javascripts', function (done) {
            assets.javascripts(done, 'queue');
        });

        gulp.task('build-sdk:queue:stylesheets', function (done) {
            assets.stylesheets(done, 'queue');
        });

        gulp.task('build-sdk:queue:templates', function (done) {
            assets.templates(done, 'queue');
        });

        gulp.task('build-sdk:queue:images', function (done) {
            assets.images(done, 'queue');
        });

        gulp.task('build-sdk:queue:fonts', function (done) {
            assets.fonts(done, 'queue');
        });

        gulp.task('build-sdk:queue:bower', function (done) {
            assets.bower(done, 'queue');
        });

        gulp.task('build-sdk:queue', [
            'build-sdk:queue:javascripts',
            'build-sdk:queue:templates',
            'build-sdk:queue:stylesheets',
            'build-sdk:queue:images',
            'build-sdk:queue:fonts',
            'build-sdk:queue:bower'
        ]);

        gulp.task('build-sdk:services:javascripts', function (done) {
            assets.javascripts(done, 'services');
        });

        gulp.task('build-sdk:services:stylesheets', function (done) {
            assets.stylesheets(done, 'services');
        });

        gulp.task('build-sdk:services:templates', function (done) {
            assets.templates(done, 'services');
        });

        gulp.task('build-sdk:services:images', function (done) {
            assets.images(done, 'services');
        });

        gulp.task('build-sdk:services:fonts', function (done) {
            assets.fonts(done, 'services');
        });

        gulp.task('build-sdk:services:bower', function (done) {
            assets.bower(done, 'services');
        });

        gulp.task('build-sdk:services', [
            'build-sdk:services:javascripts',
            'build-sdk:services:templates',
            'build-sdk:services:stylesheets',
            'build-sdk:services:images',
            'build-sdk:services:fonts',
            'build-sdk:services:bower'
        ]);

        gulp.task('build-sdk:settings:javascripts', function (done) {
            assets.javascripts(done, 'settings');
        });

        gulp.task('build-sdk:settings:stylesheets', function (done) {
            assets.stylesheets(done, 'settings');
        });

        gulp.task('build-sdk:settings:templates', function (done) {
            assets.templates(done, 'settings');
        });

        gulp.task('build-sdk:settings:images', function (done) {
            assets.images(done, 'settings');
        });

        gulp.task('build-sdk:settings:fonts', function (done) {
            assets.fonts(done, 'settings');
        });

        gulp.task('build-sdk:settings:bower', function (done) {
            assets.bower(done, 'settings');
        });

        gulp.task('build-sdk:settings', [
            'build-sdk:settings:javascripts',
            'build-sdk:settings:templates',
            'build-sdk:settings:stylesheets',
            'build-sdk:settings:images',
            'build-sdk:settings:fonts',
            'build-sdk:settings:bower'
        ]);

        gulp.task('build-sdk:queue:javascripts', function (done) {
            assets.javascripts(done, 'queue');
        });

        gulp.task('build-sdk:queue:templates', function (done) {
            assets.templates(done, 'queue');
        });

        gulp.task('build-sdk:queue:stylesheets', function (done) {
            assets.stylesheets(done, 'queue');
        });

        gulp.task('build-sdk:queue', [
            'build-sdk:queue:javascripts',
            'build-sdk:queue:templates',
            'build-sdk:queue:stylesheets',
            'build-sdk:queue:bower'
        ]);

    };

})();
