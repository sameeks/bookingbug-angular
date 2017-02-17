(function () {
    'use strict';

    var argv = require('yargs').argv;
    var fs = require('fs');
    var path = require('path');
    var git = require('gulp-git');
    var inquirer = require('inquirer');
    var prompt = inquirer.createPromptModule();

    module.exports = {
        getEnvironment: getEnvironment,
        getTestProjectRootPath: getTestProjectRootPath,
        getTestProjectSpecsRootPath: getTestProjectSpecsRootPath,
        getReleaseLog: getReleaseLog
    };

        // \/\/\/\/\/\/\/
    // GIT RELEASE LOG
    // \/\/\/\/\/\/\/\/\/
    
    function getReleaseLog() {

        var questions = [
            {
                type: 'confirm',
                name: 'gitFetchConfirm',
                message: 'Please confirm you have already run git fetch --tags',
                default: false
            }
        ];

        inquirer.prompt(questions).then(function (answers) {
            console.log("answers", answers);
            if(!answers['gitFetchConfirm']) {
                return false;
            }else {
                git.exec({
                    args: 'log v2.1.6..HEAD --oneline'
                }, function(err, stdout) {
                    var commitHistory = stdout.split('\n');
                    var commitsString = "";
                    commitHistory.forEach(function(commit){
                        var regexp = /^\w{7}\s(merge branch\s(?!master)\'*(IMPL|CORE)|\[*(CORE|IMPL)|merge pull request)(?!.+into\s(CORE|IMPL))/i;
                        if (commit.match(regexp)) {
                            commitsString += commit + "\n";
                            console.log(commit);
                        }
                    });
                    require('fs').writeFileSync('release_changelog.log', commitsString);
                });
            }
        });
    }

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
