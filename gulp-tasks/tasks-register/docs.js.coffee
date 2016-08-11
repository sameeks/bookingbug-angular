module.exports = (gulp, plugins, path)->
  gulp.task 'docs', (cb) ->
    plugins.sequence(
      'docs:clean'
      'docs:sdk-generate'
      cb
    )
    return

  gulp.task 'docs:watch', (cb) ->
    plugins.sequence(
      'docs:clean'
      'docs:sdk-generate'
      'docs:sdk-watch'
      cb
    )
    return

  return
