module.exports = (gulp, plugins, path)->
  gulpCoffee = require('gulp-coffee')
  gulpDocs = require('gulp-ngdocs')
  gulpIf = require('gulp-if')
  gulpUtil = require('gulp-util')

  gulp.task 'docs:sdk-generate', () ->
    options = {
      html5Mode: false,
      editExample: true,
      sourceLink: true,
      image: "gulp-tasks/helpers/ngdoc-templates/logo.png",
      imageLink: "gulp-tasks/helpers/ngdoc-templates/logo.png",
      navTemplate: 'gulp-tasks/helpers/ngdoc-templates/custom-head.html',
      styles: "gulp-tasks/helpers/ngdoc-templates/custom-style.css",
      loadDefaults: {
        angular: false,
        angularAnimate: false
      },
      title: "BookingBug SDK Docs",
      scripts: [
        'test/examples-archive/booking-widget.js'
      ]
    }

    return gulp.src('src/*/javascripts/**')
    .pipe(gulpIf(/.*coffee$/, gulpCoffee().on('error', gulpUtil.log)))
    .pipe(gulpDocs.process(options))
    .pipe(gulp.dest('./docs'));
