module.exports = (gulp, plugins, path)->
  gulp.task 'test-unit', (cb) ->
    plugins.sequence(
      'test-unit-bower-prepare'
      'test-unit-bower-install'
      'test-unit-start-karma'
      cb
    )
    return

  gulp.task 'test-unit:watch', (cb) ->
    plugins.sequence(
      'test-unit-bower-prepare'
      'test-unit-bower-install'
      'test-unit-start-karma:watch'
      cb
    )
    return

  return
