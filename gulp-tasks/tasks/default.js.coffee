module.exports = (gulp, plugins, path)->
  gulpConnect = require('gulp-connect')
  args = require('../args.js')

  gulp.task 'default', (cb) ->
    return plugins.sequence(
      'build-project'
      'webserver'
      cb
    )
