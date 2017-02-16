(function () {
    'use strict';

    var args = require('../helpers/args.js');

    module.exports = function (gulp, configuration) {

        var runSequence = require('run-sequence').use(gulp);

        gulp.task('release-git-log', releaseLogTask);

        function releaseLogTask(cb) {
        	args.getReleaseLog();
        }
    };

}).call(this);
