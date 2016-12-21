(function () {
  'use strict';

  var del = require('del');
  var gulpCoffee = require('gulp-coffee');
  var gulpConnect = require('gulp-connect');
  var gulpDocs = require('gulp-ngdocs');
  var gulpIf = require('gulp-if');
  var gulpUtil = require('gulp-util');

  module.exports = function (gulp, configuration) {

    gulp.task('docs:clean', function (cb) {
      del.sync(['docs']);
      cb();
    });

    gulp.task('docs:sdk-generate', function () {
      var options = {
        html5Mode: false,
        editExample: true,
        sourceLink: true,
        image: "gulp-tasks/helpers/ngdoc-templates/logo.png",
        imageLink: "gulp-tasks/helpers/ngdoc-templates/logo.png",
        navTemplate: 'gulp-tasks/helpers/ngdoc-templates/custom-head.html',
        styles: "gulp-tasks/helpers/ngdoc-templates/custom-style.css",
        title: "BookingBug SDK Docs"
      };
      return gulp.src('src/*/javascripts/**')
        .pipe(gulpIf(/.*coffee$/, gulpCoffee().on('error', gulpUtil.log)))
        .pipe(gulpDocs.process(options))
        .pipe(gulp.dest('./docs'));
    });
    return gulp.task('docs:sdk-watch', function () {
      gulp.watch('src/*/javascripts/**', ['docs:sdk-generate']);

      return gulpConnect.server({
        root: ['docs'],
        port: 8888,
        livereload: true
      });
    });
  };

}).call(this);
