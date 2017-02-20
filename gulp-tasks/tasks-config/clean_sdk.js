(function () {
    'use strict';

    let del = require('del');
    let path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('clean-sdk', cleanSdkTask);

        function cleanSdkTask(cb) {

            let buildPath = path.join(configuration.rootPath, 'build');
            let tmpPath = path.join(configuration.rootPath, 'tmp');

            let globs = [
                tmpPath + '/**',
                '!' + tmpPath,
                buildPath + '/**',
                '!' + buildPath,
                '!' + buildPath + '/booking-widget',
                '!' + buildPath + '/booking-widget/**'
            ];

            del(globs, {force: true}).then(() => {
                cb()
            });
        }
    };

}).call(this);
