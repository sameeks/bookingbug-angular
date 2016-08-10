module.exports = (gulp, plugins, path)->
  gulpConnect = require('gulp-connect')
  gulp.task 'docs:sdk-watch', () ->
    gulp.watch('src/*/javascripts/**', ['docs:sdk-generate']);

    return gulpConnect.server({
      root: ['docs']
      port: 8888
      livereload: true
    })
