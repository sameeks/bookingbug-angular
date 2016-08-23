module.exports = (gulp, configuration)->
  fs = require('fs')
  karma = require('karma')
  path = require('path')

  prepareKarmaFiles = () ->
    bowerFiles = require('main-bower-files')(
      filter: [
        '**/*.js'
      ]
      paths:
        bowerDirectory: 'test/unit/bower_components',
        bowerJson: 'test/unit/bower.json'
    )

    projectFiles = [
      'src/core/javascripts/main.js.coffee'
      'src/*/javascripts/main.js.coffee'
      'src/*/javascripts/core/config.js.coffee'
      'src/*/templates/**/*.html'
      'src/*/templates/*.html'
      'src/core/javascripts/collections/*.coffee'
      'src/*/javascripts/*.coffee'
      'src/*/javascripts/*.js'
      'src/*/javascripts/**/*.coffee'
      'src/*/javascripts/**/*.js'
    ]

    return bowerFiles.concat projectFiles

  ###
  * @param {Boolean} isDev
  ###
  getKarmaServerSettings = (isDev) ->
    serverSettings =
      configFile: path.join(__dirname, '/../karma.conf.js'),
      basePath: '../'
      files: prepareKarmaFiles()
      autoWatch: true
      singleRun: false

    if not isDev
      serverSettings.autoWatch = false
      serverSettings.singleRun = true

    return serverSettings

  gulp.task 'test-unit-start-karma:watch', (cb)->
    return new karma.Server(getKarmaServerSettings(true), cb).start()

  gulp.task 'test-unit-start-karma', (cb)->
    return new karma.Server(getKarmaServerSettings(false), cb).start()

  return
