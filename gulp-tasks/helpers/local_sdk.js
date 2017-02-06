(function () {
    'use strict';

    var fs = require('fs');
    var path = require('path');
    var sdkSrcDir = path.join(__dirname, '../../');

    module.exports = {
        generatePathToSdkBuild: generatePathToSdkBuild,
        generateSymlinkCommand: generateSymlinkCommand,
        isBBDependency: isBBDependency
    };

    /*
     * @param {String} dependencyName
     * @returns {Boolean}
     */
    function isBBDependency(dependencyName) {
        return new RegExp(/^bookingbug-angular.*/).test(dependencyName);
    }

    /*
     *@param {String} dependencyName
     */
    function generatePathToSdkBuild(dependencyName) {
        return path.join(sdkSrcDir, 'build', dependencyName.replace('bookingbug-angular-', ''), '/');
    }

    /*
     * @param {String} sdkDependency
     * @param {String} projectPath
     */
    function generateSymlinkCommand(sdkDependency, projectPath) {
        var sdkPath = path.join(sdkSrcDir, 'build', sdkDependency);
        var clientPath = path.join(projectPath, '/bower_components/bookingbug-angular-' + sdkDependency);

        return "ln -s '" + sdkPath + "' '" + clientPath + "'";
    }

}).call(this);
