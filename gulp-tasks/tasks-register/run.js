(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:run', runTask);
        gulp.task('sdk:run:watch', runWatchTask);
        gulp.task('sdk:run-for-e2e', runForE2ETask);

        function runTask(cb) {

            runSequence('sdk:release', 'sdk:webserver', 'sdk:webserver:open-browser', cb);
        }

        function runForE2ETask(cb) {

            runSequence('sdk:release', 'sdk:webserver', cb);
        }

        function runWatchTask(cb) {

            runSequence('sdk:release:watch', 'sdk:webserver', 'sdk:webserver:open-browser', cb);
        }

    };

}).call(this);
