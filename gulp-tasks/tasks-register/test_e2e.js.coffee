module.exports = (gulp, configuration)->

  runSequence = require('run-sequence')

  gulp.task 'test-e2e', (cb)->
    runSequence(
      'sdk-test-project:run-for-e2e'
      'test-e2e:prepare'
      'test-e2e:run'
      cb
    )

    return

  return
