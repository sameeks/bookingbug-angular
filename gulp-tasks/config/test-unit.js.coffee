module.exports = (gulp, plugins, growl, path)->

  fs = require('fs')
  jsonFile = require('jsonfile')
  mkDirP = require('mkdirp')


  ###
  * @param {String} dependencyName
  * @returns {Boolean}
  ###
  isBBDependency = (dependencyName) ->
    return new RegExp(/^bookingbug-angular.*/).test dependencyName

  ###
  * @param {Object.<String, String>} originDependencies
  * @param {Object.<String, String>} newNonBBDependencies
  ###
  filterOutNonBBDependencies = (originDependencies, newNonBBDependencies) ->
    for depName,depVersion of originDependencies
      if (not isBBDependency depName) && (not newNonBBDependencies.hasOwnProperty(depName) )
        newNonBBDependencies[depName] = depVersion
    return

  ###
  * @param {String} subModulePath
  ###
  prepareBowerUnitTestsFile = (subModulePath) ->
    newNonBBDependencies = {}
    bbDependencies = {}

    originBower = JSON.parse(fs.readFileSync(subModulePath + '/bower.json', 'utf8'))
    for depName,depVersion of originBower.dependencies
      if isBBDependency depName
        subModuleName = depName.replace 'bookingbug-angular-', ''
        bbDependencies[subModuleName] = depVersion

    filterOutNonBBDependencies originBower.dependencies, newNonBBDependencies

    for depName,depVersion of bbDependencies
      subModuleBower = JSON.parse(fs.readFileSync('src/' + depName + '/bower.json', 'utf8'))
      filterOutNonBBDependencies subModuleBower.dependencies, newNonBBDependencies

    originBower.dependencies = newNonBBDependencies

    mkDirP.sync  subModulePath + '/unit-tests'
    jsonFile.writeFile subModulePath + '/unit-tests/bower.json', originBower, (err) ->
      console.log err if err isnt null

    return


  commonFiles = [
    '../core/templates/**/*.html'
    '../core/templates/*.html'
    '../core/javascripts/*.coffee'
    '../core/javascripts/*.js'
    '../core/javascripts/**/*.coffee'
    '../core/javascripts/**/*.js'

    '../admin/templates/**/*.html'
    '../admin/templates/*.html'
    '../admin/javascripts/*.coffee'
    '../admin/javascripts/*.js'
    '../admin/javascripts/**/*.coffee'
    '../admin/javascripts/**/*.js'


    '../settings/templates/**/*.html'
    '../settings/templates/*.html'
    '../settings/javascripts/*.coffee'
    '../settings/javascripts/*.js'
    '../settings/javascripts/**/*.coffee'
    '../settings/javascripts/**/*.js'

    '../test-examples/templates/**/*.html'
    '../test-examples/templates/*.html'
    '../test-examples/javascripts/*.coffee'
    '../test-examples/javascripts/*.js'
    '../test-examples/javascripts/**/*.coffee'
    '../test-examples/javascripts/**/*.js'
  ]

  other = [
    '../admin-dashboard/templates/**/*.html'
    '../admin-dashboard/templates/*.html'
    '../admin-dashboard/javascripts/*.coffee'
    '../admin-dashboard/javascripts/*.js'
    '../admin-dashboard/javascripts/**/*.coffee'
    '../admin-dashboard/javascripts/**/*.js'

    '../events/templates/**/*.html'
    '../events/templates/*.html'
    '../events/javascripts/*.coffee'
    '../events/javascripts/*.js'
    '../events/javascripts/**/*.coffee'
    '../events/javascripts/**/*.js'

    '../member/templates/**/*.html'
    '../member/templates/*.html'
    '../member/javascripts/*.coffee'
    '../member/javascripts/*.js'
    '../member/javascripts/**/*.coffee'
    '../member/javascripts/**/*.js'

    '../services/templates/**/*.html'
    '../services/templates/*.html'
    '../services/javascripts/*.coffee'
    '../services/javascripts/*.js'
    '../services/javascripts/**/*.coffee'
    '../services/javascripts/**/*.js'



    '../test-examples/templates/**/*.html'
    '../test-examples/templates/*.html'
    '../test-examples/javascripts/*.coffee'
    '../test-examples/javascripts/*.js'
    '../test-examples/javascripts/**/*.coffee'
    '../test-examples/javascripts/**/*.js'

    '../admin-booking/templates/**/*.html'
    '../admin-booking/templates/*.html'
    '../admin-booking/javascripts/*.coffee'
    '../admin-booking/javascripts/*.js'
    '../admin-booking/javascripts/**/*.coffee'
    '../admin-booking/javascripts/**/*.js'

    '../services/templates/**/*.html'
    '../services/templates/*.html'
    '../services/javascripts/*.coffee'
    '../services/javascripts/*.js'
    '../services/javascripts/**/*.coffee'
    '../services/javascripts/**/*.js'
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

    deps = bowerDependencies.concat commonFiles

    console.log deps

    return deps

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


  gulp.task 'test:unit-dependencies:admin', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.admin
    cb()
    return

  gulp.task 'test:unit-dependencies:admin-booking', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.adminBooking
    cb()
    return

  gulp.task 'test:unit-dependencies:admin-dashboard', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.adminDashbaord
    cb()
    return

  gulp.task 'test:unit-dependencies:core', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.core
    cb()
    return

  gulp.task 'test:unit-dependencies:events', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.events
    cb()
    return

  gulp.task 'test:unit-dependencies:member', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.member
    cb()
    return

  gulp.task 'test:unit-dependencies:services', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.services
    cb()
    return

  gulp.task 'test:unit-dependencies:settings', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.settings
    cb()
    return

  gulp.task 'test:unit-dependencies:test-examples', (cb)->
    prepareBowerUnitTestsFile plugins.config.modulePath.testExamples
    cb()
    return

  return
