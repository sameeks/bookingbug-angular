(function () {
    'use strict';

    var del = require('del');
    var mkdirp = require('mkdirp');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk:bower-prepare', bowerPrepareTask);

        function bowerPrepareTask(cb) {

            cleanUpBowerComponents();

            cb();
        }

        function cleanUpBowerComponents() {
            mkdirp.sync(path.join(configuration.testProjectRootPath, 'bower_components'));
            var bbDependenciesToDelete = path.join(configuration.testProjectRootPath, 'bower_components/bookingbug-angular-*');
            del.sync([bbDependenciesToDelete]);
        }

    };

}).call(this);
