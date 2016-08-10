module.exports = (gulp, plugins, path)->
  gulpConnect = require('gulp-connect')
  args = require('../helpers/args.js')

  gulp.task 'default', (cb) ->
    plugins.sequence(
      'build-project'
      'webserver'
      cb
    )
    return
