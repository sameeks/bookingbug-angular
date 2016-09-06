(function () {
    'use strict';

    module.exports = function (gulp, configuration) {

        gulp.task('default', ['sdk-test-project:run:watch']);
    };

}).call(this);
