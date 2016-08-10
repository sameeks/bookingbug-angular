module.exports = (gulp, plugins, path)->
  gulp.task 'build-project', (cb) ->
    plugins.sequence(
      'build-project:clean'
      'build-sdk'
      'build-project:bower-install'
      [
        'build-project:scripts'
        'build-project:stylesheets'
        'build-project:fonts'
        'build-project:images'
        'build-project:templates'
        'build-project:www'
      ]
      cb
    )
    return

  return
