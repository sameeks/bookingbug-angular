(function () {
    'use strict';

    var argv = require('yargs').argv;
    var fs = require('fs');
    var path = require('path');

    module.exports = {
        getEnvironment: getEnvironment,
        getTestProjectRootPath: getTestProjectRootPath,
        getTestProjectSpecsRootPath: getTestProjectSpecsRootPath
    };

    /*
     * @returns {String} ['local'|'dev'|'staging'|'prod']
     */
    function getEnvironment() {
        var environment = 'dev';
        var environmentOptions = ['local', 'dev', 'staging', 'prod'];
        if (typeof argv.env !== 'undefined') {
            if (environmentOptions.indexOf(argv.env) === -1) {
                console.log('env can have one of following values: ' + environmentOptions);
                process.exit(1);
            }
            environment = argv.env;
        }
        return environment;
    }

    /**
     * @returns {String}
     */
    function getTestProjectRootPath() {

        var defaultDestPath = './test/projects/demo';
        var customDestSubPath = './test/projects';

        if (typeof argv.project !== 'undefined') {
            var projectPath = path.join(customDestSubPath, argv.project);
            try {
                fs.accessSync(projectPath, fs.F_OK);
            } catch (error1) {
                console.log(error1);
                process.exit(1);
            }
            return projectPath;
        }
        return defaultDestPath;
    }

    /**
     * @returns {String}
     */
    function getTestProjectSpecsRootPath() {
        return getTestProjectRootPath().replace('/projects/', '/e2e/');
    }

}).call(this);
