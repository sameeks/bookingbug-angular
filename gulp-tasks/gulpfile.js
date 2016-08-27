(function () {
    'use strict';

    var args = require('./helpers/args.js');
    var includeAll = require("include-all");
    var path = require("path");
    var projectConfig = require('./helpers/project_config.js');

    module.exports = function (gulp, sdkRootPath, uglify) {

        var configuration = null;

        init();

        function init() {
            loadConfiguration();
            loadTasks('tasks-config');
            loadTasks('tasks-register');
        }

        /*
         * @returns {Boolean}
         */
        function shouldUglify() {
            return ((uglify === true) || (args.getEnvironment() !== 'local' && args.getEnvironment() !== 'dev'))
        }

        function loadConfiguration() {
            configuration = {
                bbDependencies: [
                    'admin',
                    'admin-booking',
                    'admin-dashboard',
                    'core',
                    'events',
                    'member',
                    'public-booking',
                    'services',
                    'settings'
                ],
                environment: args.getEnvironment(),
                rootPath: sdkRootPath,
                testProjectConfig: projectConfig.getConfig(path.join(sdkRootPath, args.getTestProjectRootPath())),
                testProjectReleasePath: path.join(sdkRootPath, args.getTestProjectRootPath(), 'release'),
                testProjectRootPath: path.join(sdkRootPath, args.getTestProjectRootPath()),
                testProjectSpecsRootPath: path.join(sdkRootPath, args.getTestProjectSpecsRootPath()),
                testProjectTmpPath: path.join(sdkRootPath, args.getTestProjectRootPath(), 'tmp'),
                uglify: shouldUglify()
            };
        }

        function loadTasks(directory) {
            var tasks = includeAll({
                    dirname: path.resolve(__dirname, directory),
                    filter: /(.+)\.(js|coffee)$/
                }) || {};

            for (var taskName in tasks) {
                if (tasks.hasOwnProperty(taskName)) {
                    tasks[taskName](gulp, configuration);
                }
            }
        }

        return module.exports = gulp;
    };

}).call(this);
