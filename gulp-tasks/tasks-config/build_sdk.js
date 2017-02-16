(function () {
    'use strict';

    const bbGulp = require('../helpers/bb-gulp.js');

    module.exports = function (gulp, configuration) {

        bbGulp.overrideRootPath(configuration.rootPath);

        gulp.task('build-sdk:admin:javascripts', function (done) {
            bbGulp.javascripts(done, 'admin');
        });

        gulp.task('build-sdk:admin:stylesheets', function () {
            return bbGulp.stylesheets('admin');
        });

        gulp.task('build-sdk:admin:images', function () {
            return bbGulp.images('admin');
        });

        gulp.task('build-sdk:admin:fonts', function () {
            return bbGulp.fonts('admin');
        });

        gulp.task('build-sdk:admin:templates', function () {
            return bbGulp.templates('admin');
        });

        gulp.task('build-sdk:admin:bower', function () {
            return bbGulp.bower('admin');
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
            bbGulp.javascripts(done, 'admin-booking');
        });

        gulp.task('build-sdk:admin-booking:stylesheets', function () {
            return bbGulp.stylesheets('admin-booking');
        });

        gulp.task('build-sdk:admin-booking:templates', function () {
            return bbGulp.templates('admin-booking', 'BBAdminBooking');
        });

        gulp.task('build-sdk:admin-booking:images', function () {
            return bbGulp.images('admin-booking');
        });

        gulp.task('build-sdk:admin-booking:fonts', function () {
            return bbGulp.fonts('admin-booking');
        });

        gulp.task('build-sdk:admin-booking:bower', function () {
            return bbGulp.bower('admin-booking');
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
            bbGulp.javascripts(done, 'admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:stylesheets', function () {
            return bbGulp.stylesheets('admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:images', function () {
            return bbGulp.images('admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:templates', function () {
            return bbGulp.templates('admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:fonts', function () {
            return bbGulp.fonts('admin-dashboard');
        });

        gulp.task('build-sdk:admin-dashboard:bower', function () {
            return bbGulp.bower('admin-dashboard');
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
            bbGulp.javascripts(done, 'core');
        });

        gulp.task('build-sdk:core:stylesheets', function () {
            return bbGulp.stylesheets('core');
        });

        gulp.task('build-sdk:core:templates', function () {
            return bbGulp.templates('core');
        });

        gulp.task('build-sdk:core:images', function () {
            return bbGulp.images('core');
        });

        gulp.task('build-sdk:core:fonts', function () {
            return bbGulp.fonts('core');
        });

        gulp.task('build-sdk:core:bower', function () {
            return bbGulp.bower('core');
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
            bbGulp.javascripts(done, 'events');
        });

        gulp.task('build-sdk:events:stylesheets', function () {
            return bbGulp.stylesheets('events');
        });

        gulp.task('build-sdk:events:templates', function () {
            return bbGulp.templates('events');
        });

        gulp.task('build-sdk:events:images', function () {
            return bbGulp.images('events');
        });

        gulp.task('build-sdk:events:fonts', function () {
            return bbGulp.fonts('events');
        });

        gulp.task('build-sdk:events:bower', function () {
            return bbGulp.bower('events');
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
            bbGulp.javascripts(done, 'member');
        });

        gulp.task('build-sdk:member:stylesheets', function () {
            return bbGulp.stylesheets('member');
        });

        gulp.task('build-sdk:member:templates', function () {
            return bbGulp.templates('member');
        });

        gulp.task('build-sdk:member:images', function () {
            return bbGulp.images('member');
        });

        gulp.task('build-sdk:member:fonts', function () {
            return bbGulp.fonts('member');
        });

        gulp.task('build-sdk:member:bower', function () {
            return bbGulp.bower('member');
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
            bbGulp.javascripts(done, 'public-booking');
        });

        gulp.task('build-sdk:public-booking:stylesheets', function () {
            return bbGulp.stylesheets('public-booking');
        });

        gulp.task('build-sdk:public-booking:fonts', function () {
            return bbGulp.fonts('public-booking');
        });

        gulp.task('build-sdk:public-booking:images', function () {
            return bbGulp.images('public-booking');
        });

        gulp.task('build-sdk:public-booking:templates', function () {
            return bbGulp.templates('public-booking');
        });

        gulp.task('build-sdk:public-booking:bower', function () {
            return bbGulp.bower('public-booking');
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
            bbGulp.javascripts(done, 'queue');
        });

        gulp.task('build-sdk:queue:stylesheets', function () {
            return bbGulp.stylesheets('queue');
        });

        gulp.task('build-sdk:queue:templates', function () {
            return bbGulp.templates('queue');
        });

        gulp.task('build-sdk:queue:images', function () {
            return bbGulp.images('queue');
        });

        gulp.task('build-sdk:queue:fonts', function () {
            return bbGulp.fonts('queue');
        });

        gulp.task('build-sdk:queue:bower', function () {
            return bbGulp.bower('queue');
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
            bbGulp.javascripts(done, 'services');
        });

        gulp.task('build-sdk:services:stylesheets', function () {
            return bbGulp.stylesheets('services');
        });

        gulp.task('build-sdk:services:templates', function () {
            return bbGulp.templates('services');
        });

        gulp.task('build-sdk:services:images', function () {
            return bbGulp.images('services');
        });

        gulp.task('build-sdk:services:fonts', function () {
            return bbGulp.fonts('services');
        });

        gulp.task('build-sdk:services:bower', function () {
            return bbGulp.bower('services');
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
            bbGulp.javascripts(done, 'settings');
        });

        gulp.task('build-sdk:settings:stylesheets', function () {
            return bbGulp.stylesheets('settings');
        });

        gulp.task('build-sdk:settings:templates', function () {
            return bbGulp.templates('settings');
        });

        gulp.task('build-sdk:settings:images', function () {
            return bbGulp.images('settings');
        });

        gulp.task('build-sdk:settings:fonts', function () {
            return bbGulp.fonts('settings');
        });

        gulp.task('build-sdk:settings:bower', function () {
            return bbGulp.bower('settings');
        });

        gulp.task('build-sdk:settings', [
            'build-sdk:settings:javascripts',
            'build-sdk:settings:templates',
            'build-sdk:settings:stylesheets',
            'build-sdk:settings:images',
            'build-sdk:settings:fonts',
            'build-sdk:settings:bower'
        ]);
    };

}).call(this);
