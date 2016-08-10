module.exports = (gulp, plugins, path) ->
  gulp.task 'build-sdk', [
    'build-sdk:core'
    'build-sdk:public-booking'
    'build-sdk:member'
    'build-sdk:admin'
    'build-sdk:admin-booking'
    'build-sdk:admin-dashboard'
    'build-sdk:events'
    'build-sdk:services'
    'build-sdk:settings'
  ]

  gulp.task 'build-sdk:watch', [
    'build-sdk:admin:watch'
    'build-sdk:admin-booking:watch'
    'build-sdk:admin-dashboard:watch'
    'build-sdk:core:watch'
    'build-sdk:events:watch'
    'build-sdk:member:watch'
    'build-sdk:public-booking:watch'
    'build-sdk:queue:watch'
    'build-sdk:services:watch'
    'build-sdk:settings:watch'
  ]

  return
