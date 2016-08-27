(function () {
    'use strict';

    var gulpConnect = require('gulp-connect');
    var gulpOpen = require('gulp-open');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk-test-project:webserver', webServerTask);
        gulp.task('sdk-test-project:webserver:open-browser', openBrowserTask);

        function webServerTask() {
            return gulpConnect.server({
                root: [configuration.testProjectReleasePath],
                port: 8000,
                livereload: true
            });
        }

        function openBrowserTask() {

            var gulpOpenOptions = {
                uri: 'http://localhost:' + configuration.testProjectConfig.server_port + configuration.testProjectConfig.default_html
            };

            return gulp.src('')
                .pipe(gulpOpen(gulpOpenOptions));
        }
    };

}).call(this);
