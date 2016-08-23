(function () {
    'use strict';

    var gulpLiveReload = require('gulp-livereload');
    var gulpTemplate = require('gulp-template');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:www', wwwTask);

        function wwwTask() {

            var src = path.join(configuration.testProjectRootPath, 'src/www/*.*');

            return gulp.src(src)
                .pipe(gulpTemplate(configuration.testProjectConfig))
                .pipe(gulp.dest(configuration.testProjectReleasePath))
                .pipe(gulpLiveReload())
                ;
        }
    };

}).call(this);
