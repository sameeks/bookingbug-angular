(function () {
    'use strict';

    var fs = require('fs');
    var gulpBower = require('gulp-bower');
    var mkdirp = require('mkdirp');

    module.exports = function (gulp, configuration) {

        gulp.task('test-unit-bower-install', function () {
            mkdirp.sync('test/unit/bower_components');
            return gulpBower({
                cwd: 'test/unit',
                directory: './bower_components'
            });
        });
    };

}).call(this);
