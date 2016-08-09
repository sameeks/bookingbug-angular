module.exports = (gulp, plugins, path) ->
  gulpAwsPublish = require('gulp-awspublish')
  awsPublishRouter = require('gulp-awspublish-router')
  gulpRename = require('gulp-rename')

  gulp.task 'deploy', ['build-sdk', 'build-project'], () ->
    publisher = gulpAwsPublish.create
      params:
        Bucket: 'angular.bookingbug.com'
      region: 'eu-west-1'

    return gulp.src([
      './build/**'
      '!./build/*/bower_components/**'
    ])
    .pipe(gulpRename((path) ->
      path.dirname = "/#{process.env.TRAVIS_BRANCH}/#{path.dirname}"
    ))
    .pipe(publisher.publish())
    .pipe(publisher.cache())
    .pipe(gulpAwsPublish.reporter())

