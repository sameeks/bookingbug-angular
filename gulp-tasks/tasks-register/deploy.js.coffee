module.exports = (gulp, configuration) ->

  runSequence = require('run-sequence')

  gulp.task 'deploy', (cb) ->

    runSequence(
     'build-widget'
     'deploy-aws'
     cb
    )

    return
