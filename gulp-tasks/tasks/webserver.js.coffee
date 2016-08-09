module.exports = (gulp, plugins, path)->
  gulpConnect = require('gulp-connect')
  args = require('../args.js')

  gulp.task 'webserver', () ->
    gulpConnect.server {
      root: [
        path.join args.getTestProjectRootPath(), 'dist'
      ]
      port: 8000
      livereload: true
    }

    return
