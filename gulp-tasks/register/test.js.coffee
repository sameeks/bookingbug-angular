module.exports = (gulp, plugins, path)->

  gulp.task 'test:e2e', (cb)->
    plugins.sequence(
      'test:e2e:prepare',
      'test:e2e:run'
      cb
    )
