module.exports = (gulp, configuration) ->

  runSequence = require('run-sequence')

  gulp.task 'build-widget', (cb) ->

    runSequence(
      'build-sdk'
      'build-widget:bower-install'
      'build-widget:script'
      'build-widget:style'
      'build-widget:dependency-style'
      cb
    )

    return
