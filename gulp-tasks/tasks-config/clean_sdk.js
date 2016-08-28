(function () {
    'use strict';

    var del = require('del');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('clean-sdk', cleanSdkTask);

        function cleanSdkTask(cb) {

            del.sync([
                configuration.buildPath + '/**',
                '!' + configuration.buildPath,
                '!' + configuration.buildPath + '/booking-widget',
                '!' + configuration.buildPath + '/booking-widget/**'
            ], {force: true});

            cb();
        }

    };

}).call(this);
