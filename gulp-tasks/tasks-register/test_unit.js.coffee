module.exports = (gulp, configuration)->

  runSequence = require('run-sequence')

  gulp.task 'test-unit', (cb) ->
    runSequence(
      'test-unit-bower-prepare'
      'test-unit-bower-install'
      'test-unit-start-karma'
      cb
    )
    return

  gulp.task 'test-unit:watch', (cb) ->
    runSequence(
      'test-unit-bower-prepare'
      'test-unit-bower-install'
      'test-unit-start-karma:watch'
      cb
    )
    return

  return
