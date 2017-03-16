(function () {

    module.exports = function (gulp) {

        const
            eslint = require('gulp-eslint'),
            htmlhint = require('gulp-htmlhint'),
            gulpFilter = require('gulp-filter'),
            guppy = require('git-guppy')(gulp),
            sassLint = require('gulp-sass-lint');

        const
            htmlFilter = gulpFilter('**/*.html', {restore: true}),
            jsFilter = gulpFilter('**/*.js', {restore: true}),
            sassFilter = gulpFilter('**/*.scss', {restore: true});

        gulp.task('linters:es', function () {
            return gulp.src('./src/**/javascripts/**/*.js')
                .pipe(eslint())
                .pipe(eslint.format())
                .pipe(eslint.failAfterError());
        });

        gulp.task('linters:html', function () {
            return gulp.src("./src/**/templates/**/*.html")
                .pipe(htmlhint('.htmlhintrc'))
                .pipe(htmlhint.reporter("htmlhint-stylish"))
                .pipe(htmlhint.failReporter({suppress: true}));
        });

        gulp.task('linters:sass', function () {
            return gulp.src('./src/**/stylesheets/**/*.s+(a|c)ss')
                .pipe(sassLint())
                .pipe(sassLint.format())
                .pipe(sassLint.failOnError());
        });

        gulp.task('linters:guppy', function () {
            return guppy.stream('pre-commit')

                .pipe(htmlFilter)
                .pipe(htmlhint('.htmlhintrc'))
                .pipe(htmlhint.reporter("htmlhint-stylish"))
                .pipe(htmlhint.failReporter({suppress: true}))
                .pipe(htmlFilter.restore)

                .pipe(jsFilter)
                .pipe(eslint())
                .pipe(eslint.format())
                .pipe(eslint.failAfterError())
                .pipe(jsFilter.restore)

                .pipe(sassFilter)
                .pipe(sassLint())
                .pipe(sassLint.format())
                .pipe(sassLint.failOnError())
                .pipe(sassFilter.restore);
        });
    };
})();
