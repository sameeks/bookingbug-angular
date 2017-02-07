(function () {
    'use strict';

    var gulpAwsPublish = require('gulp-awspublish');
    var awsPublishRouter = require('gulp-awspublish-router');
    var gulpRename = require('gulp-rename');

    module.exports = function (gulp, configuration) {

        return gulp.task('deploy-aws', function () {

            var publisher = gulpAwsPublish.create({
                params: {
                    Bucket: 'angular.bookingbug.com'
                },
                region: 'eu-west-1'
            });

            return gulp
                .src(['./build/**', '!./build/*/bower_components/**'])
                .pipe(gulpRename(function (path) {
                    return path.dirname = "/" + process.env.TRAVIS_BRANCH + "/" + path.dirname;
                }))
                .pipe(publisher.publish())
                .pipe(publisher.cache())
                .pipe(gulpAwsPublish.reporter());
        });
    };

}).call(this);
