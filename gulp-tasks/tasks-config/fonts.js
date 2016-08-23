(function () {
    'use strict';

    var gulpFlatten = require('gulp-flatten');
    var gulpLiveReload = require('gulp-livereload');
    var mainBowerFiles = require('main-bower-files');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk-test-project:fonts', fontsTask);

        function fontsTask() {

            var dependenciesFonts = mainBowerFiles({
                includeDev: true,
                paths: {
                    bowerDirectory: path.join(configuration.testProjectRootPath, 'bower_components'),
                    bowerrc: path.join(configuration.testProjectRootPath, '.bowerrc'),
                    bowerJson: path.join(configuration.testProjectRootPath, 'bower.json')
                },
                filter: '**/*.{eot,svg,ttf,woff,woff2,otf}'
            });

            var clientFonts = path.join(configuration.testProjectRootPath, 'src/fonts/*.*');
            var dest = path.join(configuration.testProjectReleasePath, 'fonts');

            return gulp.src(dependenciesFonts.concat(clientFonts))
                .pipe(gulpFlatten())
                .pipe(gulp.dest(dest))
                .pipe(gulpLiveReload())
                ;
        }
    };

}).call(this);
