module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  del = require 'del'
  gulpBower = require('gulp-bower')
  mkdirp = require('mkdirp')

  gulp.task 'build-project:bower-install', () ->

    mkdirp.sync(path.join args.getTestProjectRootPath(), 'bower_components');

    delPathGlob = path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-*'
    del.sync([delPathGlob])

    return gulpBower({cwd: args.getTestProjectRootPath(), directory: './bower_components'})

  return
