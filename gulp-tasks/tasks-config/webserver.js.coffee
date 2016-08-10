module.exports = (gulp, plugins, path)->
  gulpConnect = require('gulp-connect')
  args = require('../helpers/args.js')

  gulp.task 'webserver', () ->
    return gulpConnect.server {
      root: [
        path.join args.getTestProjectRootPath(), 'dist'
      ]
      port: 8000
      livereload: true
    }

  return

