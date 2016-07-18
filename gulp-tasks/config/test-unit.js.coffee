module.exports = (gulp, plugins, growl, path)->
  adminDashboardModulePath = 'src/admin-dashboard'
  coreModulePath = 'src/core'
  adminModulePath = 'src/admin'
  adminBookingModulePath = 'src/admin-booking'
  eventsModulePath = 'src/events'
  memberModulePath = 'src/member'
  servicesModulePath = 'src/services'
  settingsModulePath = 'src/settings'

  getFiles = (path) ->
    bowerDependencies = require('main-bower-files')(
      filter: '**/*.js'
      paths:
        bowerDirectory: path + '/bower_components',
        bowerJson: path + '/bower.json'
    )

    commonFiles = [
      'templates/**/*.html'
      'javascripts/*.coffee'
      'javascripts/*.js'
      'javascripts/**/*.coffee'
      'javascripts/**/*.js'
    ]

    return bowerDependencies.concat commonFiles

  getKarmaServerSettings = (isDev, path) ->
    serverSettings =
      configFile: __dirname + '/../karma.conf.js',
      basePath: '../' + path
      files: getFiles path
      autoWatch: true
      singleRun: false

    if not isDev
      serverSettings.autoWatch = false
      serverSettings.singleRun = true

    return serverSettings

  gulp.task 'test:unit:core', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, coreModulePath), cb).start()

  gulp.task 'test:unit-ci:core', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, coreModulePath), cb).start()


  gulp.task 'test:unit:admin', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, adminModulePath), cb).start()

  gulp.task 'test:unit-ci:admin', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, adminModulePath), cb).start()


  gulp.task 'test:unit:admin-booking', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, adminBookingModulePath), cb).start()

  gulp.task 'test:unit-ci:admin-booking', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, adminBookingModulePath), cb).start()


  gulp.task 'test:unit:admin-dashboard', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, adminDashboardModulePath), cb).start()

  gulp.task 'test:unit-ci:admin-dashboard', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, adminDashboardModulePath), cb).start()


  gulp.task 'test:unit:events', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, eventsModulePath), cb).start()

  gulp.task 'test:unit-ci:events', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, eventsModulePath), cb).start()


  gulp.task 'test:unit:member', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, memberModulePath), cb).start()

  gulp.task 'test:unit-ci:member', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, memberModulePath), cb).start()


  gulp.task 'test:unit:services', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, servicesModulePath), cb).start()

  gulp.task 'test:unit-ci:services', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, servicesModulePath), cb).start()


  gulp.task 'test:unit:settings', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, settingsModulePath), cb).start()

  gulp.task 'test:unit-ci:settings', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, settingsModulePath), cb).start()
