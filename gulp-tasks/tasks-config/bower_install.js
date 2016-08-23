(function () {
    'use strict';

    var gulpBower = require('gulp-bower');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:bower-install', bowerInstallTask);

        function bowerInstallTask() {

            return gulpBower({
                cwd: configuration.testProjectRootPath,
                directory: './bower_components'
            });
        }
    };

}).call(this);
