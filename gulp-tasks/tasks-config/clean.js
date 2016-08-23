(function () {
    'use strict';

    var del = require('del');
    var mkdirp = require('mkdirp');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:clean', cleanTask);

        function cleanTask(cb) {

            del.sync([configuration.testProjectReleasePath]);
            mkdirp.sync(configuration.testProjectReleasePath);

            cb();
        }

    };

}).call(this);
