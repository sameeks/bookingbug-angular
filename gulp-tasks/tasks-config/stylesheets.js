(function () {
    'use strict';

    var gulpConcat = require('gulp-concat');
    var gulpCssSelectorLimit = require('gulp-css-selector-limit');
    var gulpPlumber = require('gulp-plumber');
    var gulpSass = require('gulp-sass');
    var gulpSourcemaps = require('gulp-sourcemaps');
    var gulpTemplate = require('gulp-template');
    var mainBowerFiles = require('main-bower-files');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:stylesheets:vendors', stylesheetsVendorsTask);
        gulp.task('sdk:stylesheets:client', stylesheetsClientTask);

        function filterStylesheets(path) {
            return (
                path.match(/\.css$/) && path.indexOf('bootstrap.') == -1
            );
        }

        function stylesheetsVendorsTask() {
            var dependenciesCssFiles = mainBowerFiles({
                includeDev: true,
                paths: {
                    bowerDirectory: path.join(configuration.testProjectRootPath, 'bower_components'),
                    bowerrc: path.join(configuration.testProjectRootPath, '.bowerrc'),
                    bowerJson: path.join(configuration.testProjectRootPath, 'bower.json')
                },
                filter: filterStylesheets
            });

            gulp.src(dependenciesCssFiles)
                .pipe(gulpConcat('booking-widget-dependencies.css'))
                .pipe(gulp.dest(configuration.testProjectReleasePath))
            ;
        }

        function stylesheetsClientTask() {

            var clientSCSS = path.join(configuration.testProjectRootPath, 'src/stylesheets/main.scss');

            var gulpSassOptions = {
                errLogToConsole: true,
                includePaths: [path.join(configuration.testProjectRootPath, 'bower_components/bootstrap-sass/assets/stylesheets')]
            };

            return gulp.src(clientSCSS)
                .pipe(gulpSourcemaps.init())
                .pipe(gulpPlumber())
                .pipe(gulpSass(gulpSassOptions))
                .pipe(gulpConcat('booking-widget.css'))
                .pipe(gulpTemplate(configuration.projectConfig))
                .pipe(gulpCssSelectorLimit.reporter('fail'))
                .pipe(gulpSourcemaps.write('maps', {includeContent: false}))
                .pipe(gulp.dest(configuration.testProjectReleasePath))
                ;
        }
    };

}).call(this);
