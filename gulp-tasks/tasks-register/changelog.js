(function () {
    'use strict';

    module.exports = function (gulp, configuration) {

        var runSequence = require('run-sequence').use(gulp);

        gulp.task('release-log', releaseLogTask);

        function releaseLogTask(cb) {
            runSequence('release-git-log', cb);

        }
    };

}).call(this);
