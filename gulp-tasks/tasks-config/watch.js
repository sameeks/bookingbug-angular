(function () {
    'use strict';

    var gulpLiveReload = require('gulp-livereload');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:watch', watchTask);

        function watchTask() {

            gulpLiveReload.listen();

            fonts();
            images();
            scripts();
            stylesheets();
            templates();
            www();
        }

        function www() {
            gulp.watch(configuration.testProjectRootPath + '/src/www/*.html', ['sdk:www']);
        }

        function templates() {

            gulp.watch(configuration.testProjectRootPath + '/src/templates/*.html', ['sdk:templates']);
        }

        function stylesheets() {

            gulp.watch(path.join(configuration.testProjectRootPath, '/src/stylesheets/main.scss'), ['sdk:stylesheets:client']);

            gulp
                .watch(path.join(configuration.testProjectReleasePath, 'booking-widget.css'))
                .on('change', gulpLiveReload.changed);
        }


        function scripts() {

            var projectFiles = [
                configuration.testProjectRootPath + '/src/javascripts/**/*.js',
                configuration.testProjectRootPath + '/src/javascripts/**/*.js.coffee',
                '!**/*.spec.js',
                '!**/*.spec.js.coffee',
                '!**/*.js.js',
                '!**/*.js.map'
            ];

            gulp.watch(projectFiles, ['sdk:scripts:client']);
        }

        function images() {

            gulp.watch(configuration.testProjectRootPath + '/src/images/*.*', ['sdk:images']);
        }

        function fonts() {

            gulp.watch(configuration.testProjectRootPath + '/src/fonts/*.*', ['sdk:fonts']);
        }
    };

}).call(this);
