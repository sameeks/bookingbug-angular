module.exports = (gulp, plugins, growl, path)->

  commonFiles = [
    'templates/**/*.html'
    'templates/*.html'
    'javascripts/*.coffee'
    'javascripts/*.js'
    'javascripts/**/*.coffee'
    'javascripts/**/*.js'
  ]

  getFiles = (path) ->
    bowerDependencies = require('main-bower-files')(
      filter: [
        '**/*.js'
      ]
      paths:
        bowerDirectory: path + '/unit-tests/bower_components',
        bowerJson: path + '/unit-tests/bower.json'
    )

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
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.core), cb).start()

  gulp.task 'test:unit-ci:core', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.core), cb).start()


  gulp.task 'test:unit:admin', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.admin), cb).start()

  gulp.task 'test:unit-ci:admin', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.admin), cb).start()


  gulp.task 'test:unit:admin-booking', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.adminBooking), cb).start()

  gulp.task 'test:unit-ci:admin-booking', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.adminBooking), cb).start()


  gulp.task 'test:unit:admin-dashboard', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.adminDashbaord), cb).start()

  gulp.task 'test:unit-ci:admin-dashboard', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.adminDashbaord), cb).start()


  gulp.task 'test:unit:events', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.events), cb).start()

  gulp.task 'test:unit-ci:events', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.events), cb).start()


  gulp.task 'test:unit:member', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.member), cb).start()

  gulp.task 'test:unit-ci:member', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.member), cb).start()


  gulp.task 'test:unit:services', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.services), cb).start()

  gulp.task 'test:unit-ci:services', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.services), cb).start()


  gulp.task 'test:unit:settings', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.settings), cb).start()

  gulp.task 'test:unit-ci:settings', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.settings), cb).start()

  gulp.task 'test:unit:test-examples', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(true, plugins.config.modulePath.testExamples), cb).start()

  gulp.task 'test:unit-ci:test-examples', (cb)->
    return new plugins.karma.Server(getKarmaServerSettings(false, plugins.config.modulePath.testExamples), cb).start()
