(function () {
    'use strict';

    var gulpFlatten = require('gulp-flatten');
    var gulpLiveReload = require('gulp-livereload');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk-test-project:images', imagesTask);

        function imagesTask() {

            var clientImages = path.join(configuration.testProjectRootPath, 'src/images/*.*');
            var dest = path.join(configuration.testProjectReleasePath, 'images');

            return gulp.src(clientImages)
                .pipe(gulpFlatten())
                .pipe(gulp.dest(dest))
                .pipe(gulpLiveReload())
                ;
        }
    };

}).call(this);
