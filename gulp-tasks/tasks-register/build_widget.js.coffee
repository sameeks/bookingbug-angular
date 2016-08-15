module.exports = (gulp, plugins, path) ->

  gulp.task 'build-widget', (cb) ->

    plugins.sequence(
      'build-sdk'
      'build-widget:bower-install'
      'build-widget:script'
      'build-widget:style'
      'build-widget:dependency-style'
      cb
    )

    return
