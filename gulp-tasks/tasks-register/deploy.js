(function () {
    'use strict';

    module.exports = function (gulp, configuration) {

        var runSequence = require('run-sequence').use(gulp);

        gulp.task('deploy', function (cb) {
            runSequence('build-sdk', 'deploy-aws', cb);
        });

    };

}).call(this);
