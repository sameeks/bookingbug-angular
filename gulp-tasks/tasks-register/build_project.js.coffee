module.exports = (gulp, plugins, path)->
  gulp.task 'build-project:watch-sdk-build', (cb) ->
    plugins.sequence(
      'build-project:watch-sdk-build:admin'
      'build-project:watch-sdk-build:admin-booking'
      'build-project:watch-sdk-build:admin-dashboard'
      'build-project:watch-sdk-build:core'
      'build-project:watch-sdk-build:events'
      'build-project:watch-sdk-build:member'
      'build-project:watch-sdk-build:public-booking'
      'build-project:watch-sdk-build:queue'
      'build-project:watch-sdk-build:services'
      'build-project:watch-sdk-build:settings'
      cb
    )

    return

  gulp.task 'build-project:process-top-files', (cb) ->
    plugins.sequence(
      'build-project:clean'
      'build-project:bower-install'
      'build-project:scripts'
      'build-project:stylesheets'
      'build-project:fonts'
      'build-project:images'
      'build-project:templates'
      'build-project:www'
      cb
    )

    return

  gulp.task 'build-project', (cb) ->
    plugins.sequence(
      'build-sdk'
      'build-project:process-top-files'
      cb
    )
    return

  gulp.task 'build-project:watch', (cb) ->
    plugins.sequence(
      'build-sdk'
      'build-sdk:watch'
      'build-project:process-top-files'
      'build-project:watch-sdk-build'
      cb
    )
    return

  return
