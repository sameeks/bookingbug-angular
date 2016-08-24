(function () {
    'use strict';

    var runSequence = require('run-sequence');

    module.exports = function (gulp, configuration) {

        gulp.task('build-widget', function (cb) {
            runSequence(
                'build-sdk',
                'build-widget:bower-install',
                'build-widget:script',
                'build-widget:style',
                'build-widget:dependency-style',
                cb
            );
        });

    };

}).call(this);
