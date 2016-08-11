module.exports = (gulp, plugins, path)->

  gulp.task 'build-project', (cb) ->
    plugins.sequence(
      'build-sdk'
      'build-project-clean'
      'build-project-bower-install'
      'build-project-scripts'
      'build-project-templates'
      'build-project-stylesheets'
      'build-project-fonts'
      'build-project-images'
      'build-project-www'
      cb
    )
    return

  gulp.task 'build-project:watch', (cb) ->
    plugins.sequence(
      'build-project'
      'build-project-scripts:watch'
      'build-project-templates:watch'
      'build-project-stylesheets:watch'
      cb
    )
    return

  return
