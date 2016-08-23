(function () {
    'use strict';

    var gulpCoffee = require('gulp-coffee');
    var gulpConcat = require('gulp-concat');
    var gulpIf = require('gulp-if');
    var gulpLiveReload = require('gulp-livereload');
    var gulpUglify = require('gulp-uglify');
    var gulpUtil = require('gulp-util');
    var mainBowerFiles = require('main-bower-files');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk-test-project:scripts:vendors', scriptsVendorsTask);
        gulp.task('sdk-test-project:scripts:client', scriptsClient);


        function scriptsVendorsTask() {
            var dependenciesFiles = mainBowerFiles({
                paths: {
                    bowerDirectory: path.join(configuration.testProjectRootPath, 'bower_components'),
                    bowerrc: path.join(configuration.testProjectRootPath, '.bowerrc'),
                    bowerJson: path.join(configuration.testProjectRootPath, 'bower.json')
                },
                filter: function (path) {
                    return (path.match(new RegExp('.js$'))) && (path.indexOf('bookingbug-angular-') === -1);
                }
            });
            return buildScriptsStream(dependenciesFiles, 'booking-widget-dependencies');
        }

        function scriptsClient() {

            var sdkFiles = mainBowerFiles({
                paths: {
                    bowerDirectory: path.join(configuration.testProjectRootPath, 'bower_components'),
                    bowerrc: path.join(configuration.testProjectRootPath, '.bowerrc'),
                    bowerJson: path.join(configuration.testProjectRootPath, 'bower.json')
                },
                filter: function (path) {
                    var isBookingBugDependency = path.indexOf('bookingbug-angular-') !== -1;
                    return isBookingBugDependency && path.match(new RegExp('.js$'));
                }
            });

            var projectFiles = [
                configuration.testProjectRootPath + '/src/javascripts/**/*.js',
                configuration.testProjectRootPath + '/src/javascripts/**/*.js.coffee',
                '!**/*.spec.js',
                '!**/*.spec.js.coffee',
                '!**/*.js.js',
                '!**/*.js.map'
            ];

            return buildScriptsStream(sdkFiles.concat(projectFiles), 'booking-widget')
                .pipe(gulpLiveReload())
                ;
        }

        /*
         * @param {Array.<String>} files
         * @param {String} filename
         */
        function buildScriptsStream(files, filename) {
            var stream = gulp.src(files)
                    .pipe(gulpIf(/.*js.coffee$/, gulpCoffee().on('error', gulpUtil.log)))
                    .pipe(gulpConcat(filename + '.js'))
                    .pipe(gulp.dest(configuration.testProjectReleasePath))
                ;

            return stream;
        }

    };

}).call(this);
