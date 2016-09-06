(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('test-unit', function (cb) {
            runSequence('test-unit-bower-prepare', 'test-unit-bower-install', 'test-unit-start-karma', cb);
        });
        gulp.task('test-unit:watch', function (cb) {
            runSequence('test-unit-bower-prepare', 'test-unit-bower-install', 'test-unit-start-karma:watch', cb);
        });
    };

}).call(this);
