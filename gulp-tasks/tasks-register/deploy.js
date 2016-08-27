(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('deploy', function (cb) {
            runSequence('build-widget', 'deploy-aws', cb);
        });

    };

}).call(this);
