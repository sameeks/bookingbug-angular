module.exports = (gulp, plugins, path)->
  del = require('del')
  gulpif = require('gulp-if')
  gulpDocs = require('gulp-ngdocs')
  coffee = require('gulp-coffee')
  gutil = require('gulp-util')

  gulp.task 'docs:cleanup', (cb) ->
    del.sync(['docs']);
    cb()

  gulp.task 'docs:ng', () ->
    options = {
      html5Mode: false,
      editExample: true,
      sourceLink: true,
      image: "gulp-tasks/ngdoc-templates/logo.png",
      imageLink: "gulp-tasks/ngdoc-templates/logo.png",
      navTemplate: 'gulp-tasks/ngdoc-templates/custom-head.html',
      styles: "gulp-tasks/ngdoc-templates/custom-style.css",
      loadDefaults: {
        angular: false,
        angularAnimate: false
      },
      title: "BookingBug SDK Docs",
      scripts: [
        'examples/booking-widget.js'
      ]
    }

    return gulp.src('src/*/javascripts/**')
    .pipe(gulpif(/.*coffee$/, coffee().on('error', gutil.log)))
    .pipe(gulpDocs.process(options))
    .pipe(gulp.dest('./docs'));


  gulp.task 'docs', ['docs:cleanup', 'docs:ng'], (cb) ->
    gulp.watch('src/*/javascripts/**', ['docs:ng']);

    return connect.server({
      root: ['docs'],
      port: 8000
    })
