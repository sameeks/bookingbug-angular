(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('docs', function (cb) {
            runSequence('docs:clean', 'docs:sdk-generate', cb);
        });

        gulp.task('docs:watch', function (cb) {
            runSequence('docs:clean', 'docs:sdk-generate', 'docs:sdk-watch', cb);
        });
    };

}).call(this);
