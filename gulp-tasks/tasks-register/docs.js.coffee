module.exports = (gulp, configuration)->

  runSequence = require('run-sequence')

  gulp.task 'docs', (cb) ->
    runSequence(
      'docs:clean'
      'docs:sdk-generate'
      cb
    )
    return

  gulp.task 'docs:watch', (cb) ->
    runSequence(
      'docs:clean'
      'docs:sdk-generate'
      'docs:sdk-watch'
      cb
    )
    return

  return
