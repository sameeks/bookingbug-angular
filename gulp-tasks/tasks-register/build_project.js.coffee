module.exports = (gulp, plugins, path)->

  gulp.task 'build-project', (cb) ->
    plugins.sequence(
      'build-sdk'
      'build-project:clean'
      'build-project:bower-install'
      'build-project:scripts'
      'build-project:stylesheets'
      'build-project:fonts'
      'build-project:images'
      'build-project:templates'
      'build-project:www'
      cb
    )
    return

  gulp.task 'build-project:watch', (cb) ->
    plugins.sequence(
      'build-project'
      'build-project:scripts:watch'
      'build-project:templates:watch'
      cb
    )
    return

  return
