module.exports = (gulp, configuration)->
  fs = require('fs')
  gulpBower = require('gulp-bower')
  mkdirp = require('mkdirp')

  gulp.task 'test-unit-bower-install', (cb)->
    mkdirp.sync('test/unit/bower_components');
    return gulpBower({cwd: 'test/unit', directory: './bower_components'})

    cb()
    return

  return
