(function () {
    'use strict';

    module.exports = function (gulp, configuration) {

        gulp.task('release', [
            'release-git:admin',
            'release-git:admin-booking',
            'release-git:admin-dashboard',
            'release-git:core',
            'release-git:events',
            'release-git:member',
            'release-git:public-booking',
            'release-git:queue'
        ], function () {
            process.exit();
        });

    };

}).call(this);
