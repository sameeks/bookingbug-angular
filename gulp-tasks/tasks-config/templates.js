(function () {
    'use strict';

    var gulpAngularTemplateCache = require('gulp-angular-templatecache');
    var gulpConcat = require('gulp-concat');
    var gulpLiveReload = require('gulp-livereload');
    var gulpUglify = require('gulp-uglify');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:templates', templatesTask);

        function templatesTask() {

            var clientTemplates = path.join(configuration.testProjectRootPath, 'src/templates/**/*.html');

            var stream = gulp.src(clientTemplates)
                    .pipe(gulpAngularTemplateCache('booking-widget-templates.js', {
                        module: 'TemplateOverrides',
                        standalone: true
                    }))
                    .pipe(gulp.dest(configuration.testProjectReleasePath))
                ;

            return stream
                .pipe(gulpLiveReload())
                ;
        }
    };

}).call(this);
