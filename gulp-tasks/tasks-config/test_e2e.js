(function () {
    'use strict';

    var args = require('../helpers/args.js');
    var path = require('path');
    var protractor = require('gulp-protractor');
    var sauceConnectLauncher = require('sauce-connect-launcher');

    module.exports = function (gulp, configuration) {

        var launchSauceConnect = function (cb) {
            sauceConnectLauncher({
                username: 'bookingbug-angular',
                accessKey: process.env.SAUCELABS_SECRET
            }, cb);
        };

        gulp.task('test-e2e:prepare', process.env.TRAVIS ? launchSauceConnect : protractor.webdriver_update);

        gulp.task('test-e2e:run', function () {
            return gulp
                .src([path.join(args.getTestProjectSpecsRootPath(), '**/*.spec.js.coffee')])
                .pipe(protractor.protractor({
                    configFile: 'gulp-tasks/protractor.conf.js'
                })).on('end', function () {
                    process.exit(0);
                }).on('error', function (message) {
                    console.error(message);
                    process.exit(1);
                });
        });
    };

}).call(this);
