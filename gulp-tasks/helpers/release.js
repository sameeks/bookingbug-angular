(function () {
    'use strict';

    const git = require('gulp-git');
    const del = require('del');
    const gulp = require('gulp');
    const replace = require('gulp-replace');
    const gulpIf = require('gulp-if');
    const gutil = require('gulp-util');

    let gitTagAndPush = function (done, version, branchName, gitDir) {
        git.tag(version, `Version ${version}`, {cwd: gitDir}, function (err) {
            if (err) {
                gutil.log(err);
                return done();
            } else {
                git.push('origin', branchName, {args: '--tags'}, function (err) {
                    if (err) {
                        gutil.log(err);
                        return done();
                    } else {
                        return done();
                    }
                });
            }
        });
    }

    let gitCommit = function (done, version, branchName, gitDir) {
        gulp.src('./*', {cwd: gitDir})
          .pipe(git.add())
          .pipe(git.commit(`Update to version: ${version}`, {args: '--allow-empty', cwd: gitDir}))
          .on('error', function (err) {
              gutil.log(err);
              return done();
          })
          .on('end', function () {
              return gitTagAndPush(done, version, branchName, gitDir);
          });
    }

    let copyAndCommit = function (done, version, branchName, gitDir, buildDir) {
        gulp.src(buildDir+'/*')
            .pipe(gulpIf(/bower.json/, replace(/master/, version)))
            .pipe(gulp.dest(gitDir))
            .on('error', function (err) {
                gutil.log(err);
                return done();
            })
            .on('end', function () {
                return gitCommit(done, version, branchName, gitDir);
            });
    }

    module.exports = {
        git: function (done, module) {
            let version = process.env.TRAVIS_TAG;
            let gitUrl = `https://github.com/BookingBug/bookingbug-angular-${module}-bower`
            let gitDir = `bookingbug-angular-${module}-bower`;
            let buildDir = `build/${module}`
            let branchName = 'version' + version.match(/v(\d+.\d+).\d+/)[1];
            del.sync(gitDir);
            gutil.log(module + ' cloning ' + gitUrl);
            git.clone(gitUrl, function (err) {
                git.checkout(branchName, {cwd: gitDir}, function (err) {
                    if (err) {
                        git.checkout(branchName, {args: '-b', cwd: gitDir}, function (err) {
                            return copyAndCommit(done, version, branchName, gitDir, buildDir);
                        });
                    } else {
                        return copyAndCommit(done, version, branchName, gitDir, buildDir);
                    }
                });
            });
        }
    }


}).call(this);
