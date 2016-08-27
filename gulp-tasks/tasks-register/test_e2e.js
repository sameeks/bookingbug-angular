(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('test-e2e', function (cb) {
            runSequence('sdk-test-project:run-for-e2e', 'test-e2e:prepare', 'test-e2e:run', cb);
        });

    };

}).call(this);
