(function () {
    'use strict';

    const release = require('../helpers/release.js');

    module.exports = function (gulp, configuration) {

        gulp.task('release-git:admin', ['build-sdk:admin'], function (done) {
            release.git(done, 'admin');
        });

        gulp.task('release-git:admin-booking', ['build-sdk:admin-booking'], function (done) {
            release.git(done, 'admin-booking');
        });

        gulp.task('release-git:admin-dashboard', ['build-sdk:admin-dashboard'], function (done) {
            release.git(done, 'admin-dashboard');
        });

        gulp.task('release-git:core', ['build-sdk:core'], function (done) {
            release.git(done, 'core');
        });

        gulp.task('release-git:events', ['build-sdk:events'], function (done) {
            release.git(done, 'events');
        });

        gulp.task('release-git:member', ['build-sdk:member'], function (done) {
            release.git(done, 'member');
        });

        gulp.task('release-git:public-booking', ['build-sdk:public-booking'], function (done) {
            release.git(done, 'public-booking');
        });

        gulp.task('release-git:queue', ['build-sdk:queue'], function (done) {
            release.git(done, 'queue');
        });

    };

}).call(this);
