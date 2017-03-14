(function () {
    'use strict';

    module.exports = function (gulp) {
        const runSequence = require('run-sequence').use(gulp);

        gulp.task('pre-commit', function (cb) {
            runSequence('linters:guppy', cb);
        });
    };
})();
