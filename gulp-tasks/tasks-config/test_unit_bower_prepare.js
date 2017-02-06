(function () {
    'use strict';

    var fs = require('fs');
    var jsonFile = require('jsonfile');
    var mkDirP = require('mkdirp');
    var path = require('path');

    module.exports = function (gulp, configuration) {

        /*
         * @param {String} dependencyName
         * @returns {Boolean}
         */
        var isBBDependency = function (dependencyName) {
            return new RegExp(/^bookingbug-angular.*/).test(dependencyName);
        };

        gulp.task('test-unit-bower-prepare', function (cb) {
            var nonBBDependencies = {};

            var testBowerJson = JSON.parse(fs.readFileSync('test/unit/bower.json', 'utf8'));

            var orderedSubModulesNames = ['core', 'admin', 'admin-booking', 'events', 'member', 'services', 'settings', 'test-examples', 'admin-dashboard'];

            for (var i = 0, len = orderedSubModulesNames.length; i < len; i++) {
                var subModuleName = orderedSubModulesNames[i];
                var bowerJson = JSON.parse(fs.readFileSync(path.join('src', subModuleName, '/bower.json'), 'utf8'));
                var ref = bowerJson.dependencies;
                for (var depName in ref) {
                    var depVersion = ref[depName];
                    if (!isBBDependency(depName)) {
                        nonBBDependencies[depName] = depVersion;
                    }
                }
            }
            testBowerJson.name = 'bb-unit-test';
            testBowerJson.dependencies = nonBBDependencies;

            mkDirP.sync('test/unit');

            jsonFile.writeFile('test/unit/bower.json', testBowerJson, {
                spaces: 2
            }, function (err) {
                if (err !== null) {
                    return console.log(err);
                }
            });

            cb();
        });
    };

}).call(this);
