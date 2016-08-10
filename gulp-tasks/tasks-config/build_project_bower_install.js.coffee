module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  del = require 'del'
  gulpBower = require('gulp-bower')
  gulpShell = require('gulp-shell')
  mkdirp = require('mkdirp')

  gulp.task 'build-sdk:bower-link', gulpShell.task [
    'cd build/admin && bower link'
    'cd build/admin-booking && bower link'
    'cd build/admin-dashboard && bower link'
    'cd build/core && bower link'
    'cd build/events && bower link'
    'cd build/member && bower link'
    'cd build/public-booking && bower link'
    'cd build/services && bower link'
    'cd build/settings && bower link'
  ]

  gulp.task 'build-project:bower-link-sdk', () ->

    projectPath = args.getTestProjectRootPath()

    ###
    if [[ -L "$file" && -d "$file" ]]
    then
        echo "$file is a symlink to a directory"
    fi

    if [ ! -d /etc/nginx ]; then ln -s /usr/local/nginx/conf/ /etc/nginx > /dev/null 2>&1; fi

    ln -s /home/damian/workspace_js/bookingbug-angular-bespoke/bookingbug-angular/build/core /home/damian/workspace_js/bookingbug-angular-bespoke/bookingbug-angular/test/projects/demo/bower_components/bookingbug-angular-core

    ###

    gulp.src('').pipe gulpShell [
      'cd ' + projectPath + ' && bower link bookingbug-angular-admin'
      'cd ' + projectPath + ' && bower link bookingbug-angular-admin-booking'
      'cd ' + projectPath + ' && bower link bookingbug-angular-admin-dashboard'
      'cd ' + projectPath + ' && bower link bookingbug-angular-core'
      'cd ' + projectPath + ' && bower link bookingbug-angular-events'
      'cd ' + projectPath + ' && bower link bookingbug-angular-member'
      'cd ' + projectPath + ' && bower link bookingbug-angular-public-booking'
      'cd ' + projectPath + ' && bower link bookingbug-angular-services'
      'cd ' + projectPath + ' && bower link bookingbug-angular-settings'
    ], {
      ignoreErrors: true
    }
    return

  ###
  * @param {String} sdkDependency
  ###
  generateSymlinkCommand = (sdkDependency) ->
    buildPath = path.join __dirname, '../../build/'
    projectPath = path.join __dirname, '../..', args.getTestProjectRootPath(), 'bower_components/'

    return 'ln -s ' + buildPath + sdkDependency + ' ' + projectPath + 'bookingbug-angular-' + sdkDependency


  gulp.task 'build-project:bower-install', () ->

    mkdirp.sync(path.join args.getTestProjectRootPath(), 'bower_components');

    gulp.src('').pipe gulpShell [
      generateSymlinkCommand('admin')
      generateSymlinkCommand('admin-booking')
      generateSymlinkCommand('admin-dashboard')
      generateSymlinkCommand('core')
      generateSymlinkCommand('events')
      generateSymlinkCommand('member')
      generateSymlinkCommand('public-booking')
      generateSymlinkCommand('services')
      generateSymlinkCommand('settings')
    ], {
      ignoreErrors: true
    }

    ###delPathGlob = path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-*'
    del.sync([delPathGlob])###

    return gulpBower({cwd: args.getTestProjectRootPath(), directory: './bower_components'})

  return
