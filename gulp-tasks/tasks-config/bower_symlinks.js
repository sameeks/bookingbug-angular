(function () {
    'use strict';

    var fs = require('fs');
    var gulpShell = require('gulp-shell');
    var jsonFile = require('jsonfile');
    var localSdk = require('../helpers/local_sdk');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        gulp.task('sdk-test-project:bower-symlinks', bowerSymlinksTask);

        function bowerSymlinksTask(cb) {

            createSymlinks();
            overrideBBDependenciesInSDKBuilds();

            cb();
        }

        function createSymlinks() {

            var commandsToExecute = [];

            for (var depKey in configuration.bbDependencies) {
                var depName = configuration.bbDependencies[depKey];
                commandsToExecute.push(localSdk.generateSymlinkCommand(depName, configuration.testProjectRootPath));
            }

            gulp.src('').pipe(gulpShell(commandsToExecute, {ignoreErrors: true}));
        }

        function overrideBBDependenciesInSDKBuilds() {

            for (var depIndex in configuration.bbDependencies) {
                var depName = configuration.bbDependencies[depIndex];

                var sdkBowerPath = path.join(configuration.rootPath, 'build', depName, 'bower.json');
                var sdkBowerJson = JSON.parse(fs.readFileSync(sdkBowerPath, 'utf8'));

                for (var dep in sdkBowerJson.dependencies) {
                    if (localSdk.isBBDependency(dep)) {
                        sdkBowerJson.dependencies[dep] = localSdk.generatePathToSdkBuild(dep);
                    }
                }

                jsonFile.writeFile(sdkBowerPath, sdkBowerJson, {spaces: 2}, function (err) {
                    if (err !== null) {
                        return console.log(err);
                    }
                });
            }
        }

    };

}).call(this);
