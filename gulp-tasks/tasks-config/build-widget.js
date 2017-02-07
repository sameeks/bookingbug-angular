(function () {
    'use strict';

    var bower = require('gulp-bower');
    var concat = require('gulp-concat');
    var cssSelectorLimit = require('gulp-css-selector-limit');
    var mainBowerFiles = require('main-bower-files');
    var plumber = require('gulp-plumber');
    var sass = require('gulp-sass');
    var sourcemaps = require('gulp-sourcemaps');
    var uglify = require('gulp-uglify');

    module.exports = function (gulp, configuration) {

        gulp.task('build-widget:bower-install', function () {
            return bower({
                cwd: './build/booking-widget',
                directory: './bower_components'
            });
        });

        gulp.task('build-widget:script', function () {
            return gulp
                .src(mainBowerFiles({
                    filter: new RegExp('.js$'),
                    paths: {
                        bowerDirectory: './build/booking-widget/bower_components',
                        bowerJson: './build/booking-widget/bower.json'
                    }
                }))
                .pipe(concat('booking-widget.js'))
                .pipe(gulp.dest('./build/booking-widget/dist'))
                .pipe(uglify({
                    mangle: false
                }))
                .pipe(concat('booking-widget.min.js'))
                .pipe(gulp.dest('./build/booking-widget/dist'));
        });

        gulp.task('build-widget:style', function () {
            return gulp
                .src('./build/booking-widget/src/stylesheets/main.scss')
                .pipe(sourcemaps.init())
                .pipe(plumber())
                .pipe(sass({
                    includePaths: ['./build/booking-widget/bower_components/bootstrap-sass/assets/stylesheets'],
                    outputStyle: 'compressed',
                    errLogToConsole: true
                }))
                .pipe(concat('booking-widget.css'))
                .pipe(cssSelectorLimit.reporter('fail'))
                .pipe(sourcemaps.write('maps', {
                    includeContent: false
                }))
                .pipe(gulp.dest('./build/booking-widget/dist'));
        });

        var filterStylesheets = function (path) {
            return path.match(new RegExp('.css$')) && !path.match(new RegExp('(bower_components\/bookingbug-angular-).+(\.css)')) && path.indexOf('bootstrap.') === -1;
        };

        gulp.task('build-widget:dependency-style', function () {
            return gulp
                .src(mainBowerFiles({
                    includeDev: true,
                    filter: filterStylesheets,
                    paths: {
                        bowerDirectory: './build/booking-widget/bower_components',
                        bowerJson: './build/booking-widget/bower.json'
                    }
                }))
                .pipe(concat('booking-widget-dependencies.css'))
                .pipe(gulp.dest('./build/booking-widget/dist'));
        });
    };

}).call(this);
