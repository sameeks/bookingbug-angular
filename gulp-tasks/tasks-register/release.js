(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:release', releaseTask);
        gulp.task('sdk:release:watch', releaseWatchTask);

        function releaseTask(cb) {

            var tasks = [
                'build-sdk',
                'sdk:clean',
                'sdk:bower-prepare',
                'sdk:bower-symlinks',
                'sdk:bower-install',
                'sdk:scripts:vendors',
                'sdk:scripts:client',
                'sdk:templates',
                'sdk:stylesheets:vendors',
                'sdk:stylesheets:client',
                'sdk:fonts',
                'sdk:images',
                'sdk:www',
                cb
            ];

            runSequence.apply(null, tasks);
        }

        function releaseWatchTask(cb) {

            runSequence(
                'sdk:release',
                'sdk:watch',
                'sdk:watch-sdk',
                cb
            );
        }
    };

}).call(this);
