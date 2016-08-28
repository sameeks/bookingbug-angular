(function () {
    'use strict';

    var buildSdk = require('../helpers/build_sdk.js');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        var srcPath = path.join(configuration.rootPath, 'src');
        var destPath = path.join(configuration.rootPath, 'build');

        gulp.task('build-sdk:admin:javascripts', function () {
            return buildSdk.javascripts('admin', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:admin:images', function () {
            return buildSdk.images('admin', srcPath, destPath);
        });

        gulp.task('build-sdk:admin:templates', function () {
            return buildSdk.templates('admin', srcPath, destPath);
        });

        gulp.task('build-sdk:admin:bower', function () {
            return buildSdk.bower('admin', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:admin-booking:javascripts', function () {
            buildSdk.javascripts('admin-booking', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:admin-booking:stylesheets', function () {
            return buildSdk.stylesheets('admin-booking', srcPath, destPath);
        });

        gulp.task('build-sdk:admin-booking:templates', function () {
            return buildSdk.templates('admin-booking', srcPath, destPath, 'BBAdminBooking');
        });

        gulp.task('build-sdk:admin-booking:bower', function () {
            return buildSdk.bower('admin-booking', srcPath, destPath, 'BBAdminBooking');
        });

        //***

        gulp.task('build-sdk:admin-dashboard:javascripts-core', function () {
            return buildSdk.javascriptsCore('admin-dashboard', srcPath, destPath, 'BBAdminDashboard', configuration.uglify);
        });

        gulp.task('build-sdk:admin-dashboard:javascripts-lazy', function () {
            return buildSdk.javascriptsLazy('admin-dashboard', srcPath, destPath, 'BBAdminDashboard', configuration.uglify);
        });

        gulp.task('build-sdk:admin-dashboard:stylesheets', function () {
            return buildSdk.stylesheets('admin-dashboard', srcPath, destPath);
        });

        gulp.task('build-sdk:admin-dashboard:images', function () {
            return buildSdk.images('admin-dashboard', srcPath, destPath);
        });

        gulp.task('build-sdk:admin-dashboard:bower', function () {
            return buildSdk.bower('admin-dashboard', srcPath, destPath);
        });

        //***


        gulp.task('build-sdk:core:javascripts', function () {
            return buildSdk.javascripts('core', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:core:stylesheets', function () {
            return buildSdk.stylesheets('core', srcPath, destPath);
        });

        gulp.task('build-sdk:core:templates', function () {
            return buildSdk.templates('core', srcPath, destPath);
        });

        gulp.task('build-sdk:core:bower', function () {
            return buildSdk.bower('core', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:events:javascripts', function () {
            return buildSdk.javascripts('events', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:events:templates', function () {
            return buildSdk.templates('events', srcPath, destPath);
        });

        gulp.task('build-sdk:events:bower', function () {
            return buildSdk.bower('events', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:member:javascripts', function () {
            return buildSdk.javascripts('member', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:member:stylesheets', function () {
            return buildSdk.stylesheets('member', srcPath, destPath);
        });

        gulp.task('build-sdk:member:templates', function () {
            return buildSdk.templates('member', srcPath, destPath);
        });

        gulp.task('build-sdk:member:bower', function () {
            return buildSdk.bower('member', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:public-booking:javascripts', function () {
            return buildSdk.javascripts('public-booking', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:public-booking:stylesheets', function () {
            return buildSdk.stylesheets('public-booking', srcPath, destPath);
        });

        gulp.task('build-sdk:public-booking:fonts', function () {
            return buildSdk.fonts('public-booking', srcPath, destPath);
        });

        gulp.task('build-sdk:public-booking:images', function () {
            return buildSdk.images('public-booking', srcPath, destPath);
        });

        gulp.task('build-sdk:public-booking:templates', function () {
            return buildSdk.templates('public-booking', srcPath, destPath);
        });

        gulp.task('build-sdk:public-booking:bower', function () {
            return buildSdk.bower('public-booking', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:queue:javascripts', function () {
            return buildSdk.javascripts('queue', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:queue:templates', function () {
            return buildSdk.templates('queue', srcPath, destPath);
        });

        gulp.task('build-sdk:queue:bower', function () {
            return buildSdk.bower('queue', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:services:javascripts', function () {
            return buildSdk.javascripts('services', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:services:stylesheets', function () {
            return buildSdk.stylesheets('services', srcPath, destPath);
        });

        gulp.task('build-sdk:services:templates', function () {
            return buildSdk.templates('services', srcPath, destPath);
        });

        gulp.task('build-sdk:services:bower', function () {
            return buildSdk.bower('services', srcPath, destPath);
        });

        //***

        gulp.task('build-sdk:settings:javascripts', function () {
            return buildSdk.javascripts('settings', srcPath, destPath, configuration.uglify);
        });

        gulp.task('build-sdk:settings:templates', function () {
            return buildSdk.templates('settings', srcPath, destPath);
        });

        gulp.task('build-sdk:settings:bower', function () {
            return buildSdk.bower('settings', srcPath, destPath);
        });

    };

}).call(this);
