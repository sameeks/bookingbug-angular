module.exports = (gulp, plugins, growl, path) ->

  awspublish = require('gulp-awspublish')
  awspublishRouter = require('gulp-awspublish-router')
  rename = require('gulp-rename')

  gulp.task 'deploy', () ->
    publisher = awspublish.create
      key: process.env.ACCESS_KEY_ID
      secret: process.env.SECRET_ACCESS_KEY
      params:
        Bucket: 'angular.bookingbug.com'
      region: 'eu-west-1'
    gulp.src(['./build/**','!./build/*/bower_components/**'])
      .pipe(rename((path) ->
        path.dirname = "/#{process.env.TRAVIS_TAG}/#{path.dirname}"
      ))
      .pipe(publisher.publish())
      .pipe(publisher.cache())
      .pipe(awspublish.reporter())

