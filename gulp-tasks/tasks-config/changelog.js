(function () {
    'use strict';

    var fs = require('fs');
    var git = require('gulp-git');
    var inquirer = require('inquirer');
    var gulpUtil = require('gulp-util');

    module.exports = function (gulp, configuration) {

        function getReleaseLog() {

            var questions = [
                {
                    type: 'confirm',
                    name: 'gitFetchConfirm',
                    message: 'Please confirm you have already run git fetch --tags',
                    default: false
                },
                {
                    type: 'input',
                    name: 'fromTag',
                    message: 'Please specify the release tag you want to track changes FROM (usually the most recent release, for ex: v2.1.6)',
                    validate: function (answer) {
                        if(answer.match(/v\d+\.\d+\.\d+/)) {
                            return true;
                        }
                        return 'Invalid tag!';
                    }
                },
                {
                    type: 'input',
                    name: 'toTag',
                    message: 'Please specify the release tag you want to track changes TO. Default:',
                     validate: function (answer) {
                        if(answer.match(/(v\d+\.\d+\.\d+|HEAD)/)) {
                            return true;
                        }
                        return 'Invalid tag!';
                    },
                    default: 'HEAD'
                }
            ];

            inquirer.prompt(questions).then(function (answers) {

                var gitLogString = "log " + answers['fromTag'] + ".." + answers['toTag'] + " --oneline";

                if(!answers['gitFetchConfirm']) {
                    return false;
                }else {
                    git.exec({
                        args: gitLogString
                    }, function(err, stdout) {
                        var commitHistory = stdout.split('\n');
                        var commitsString = "\n";
                        var allCommitsString = "\n";
                        commitHistory.forEach(function(commit){
                            // filter relevant commits
                            var regexp = /^\w{7}\s(merge branch\s(?!master)\'*(IMPL|CORE)|\[*(CORE|IMPL)|merge pull request)(?!.+into\s(CORE|IMPL))/i;
                            if (commit.match(regexp)) {
                                commitsString += commit + "\n";
                            }
                            allCommitsString += commit + "\n";
                        });
                        var commandStr = "git ";
                        var notifyFilterStr = "\n\n>>>\nNOTE: This commit history has been filtered and does not contain all the commits between " + answers['fromTag'] + " and " + answers['toTag'] + "\n<<<";
                        // save git commit historys to file, prepending the git log command to first line (for reference)
                        fs.writeFileSync('./tmp/release_changelog.log', commandStr.concat(gitLogString, notifyFilterStr + "\n", commitsString));
                        fs.writeFileSync('./tmp/release_changelog_ALL_COMMITS.log', commandStr.concat(gitLogString, "\n", allCommitsString));
                        // log git commit history to console
                        gulpUtil.log(gulpUtil.colors.gray(commitsString));
                        // notify user of changelog path
                        gulpUtil.log(gulpUtil.colors.green("*** Commit History saved to file: ") + gulpUtil.colors.yellow("tmp/release_changelog.log ***"));
                    });
                }
            });
        }

        gulp.task('release-git-log', releaseLogTask);

        function releaseLogTask(cb) {
            getReleaseLog();
        }
    };

}).call(this);
