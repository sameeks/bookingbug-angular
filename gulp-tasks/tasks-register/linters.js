(function () {
    'use strict';

    module.exports = function (gulp) {
        const runSequence = require('run-sequence').use(gulp);

        gulp.task('linters:all', function (cb) {
            runSequence('linters:es', 'linters:html', 'linters:sass', cb);
        });
    };

})();
