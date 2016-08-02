module.exports = (gulp, plugins, path)->
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
  * @param {Object}
  * @returns {Object.<String, String>}
  ###
  findBBDependencies = (bowerJson) ->
    bbDependencies = {}

    for depName,depVersion of bowerJson.dependencies
      if isBBDependency depName
        subModuleName = depName.replace 'bookingbug-angular-', ''
        bbDependencies[subModuleName] = depVersion

    return bbDependencies

  ###
  * @param {String} modulePath
  ###
  prepareBowerUnitTestsFile = (modulePath) ->
    newNonBBDependencies = {}

    originBower = JSON.parse(fs.readFileSync(path.join(modulePath, '/bower.json'), 'utf8'))
    bbDependencies = findBBDependencies(originBower)

    filterOutNonBBDependencies originBower.dependencies, newNonBBDependencies

    for depName,depVersion of bbDependencies
      subModuleBower = JSON.parse(fs.readFileSync(path.join('src/', depName, '/bower.json'), 'utf8'))
      filterOutNonBBDependencies subModuleBower.dependencies, newNonBBDependencies

    originBower.dependencies = newNonBBDependencies

    mkDirP.sync path.join(modulePath, '/unit-tests')
    jsonFile.writeFile path.join(modulePath, '/unit-tests/bower.json'), originBower, (err) ->
      console.log err if err isnt null

    return bbDependencies


  ###
  * @param {String} moduleName
  ###
  moduleFiles = (moduleName) ->
    return [
      '../' + moduleName + '/templates/**/*.html'
      '../' + moduleName + '/templates/*.html'
      '../' + moduleName + '/javascripts/*.coffee'
      '../' + moduleName + '/javascripts/*.js'
      '../' + moduleName + '/javascripts/**/*.coffee'
      '../' + moduleName + '/javascripts/**/*.js'
    ]

  ###
  * @param {String} moduleName
  ###
  moduleSpecFiles = (moduleName) ->
    return [
      '../!(' + moduleName + ')/javascripts/*.spec.js.coffee'
      '../!' + moduleName + ')/javascripts/*.spec.js'
      '../!(' + moduleName + ')/javascripts/**/*.spec.js.coffee'
      '../!(' + moduleName + ')/javascripts/**/*.spec.js'
    ]

  ###
  * @param {String} modulePath
  * @param {Object.<String, String>} bbDependencies
  ###
  prepareKarmaFiles = (modulePath, bbDependencies) ->
    bowerFiles = require('main-bower-files')(
      filter: [
        '**/*.js'
      ]
      paths:
        bowerDirectory: path.join(modulePath, '/unit-tests/bower_components'),
        bowerJson: path.join(modulePath, '/unit-tests/bower.json')
    )

    projectFiles = []

    for bbModuleName of bbDependencies
      projectFiles = projectFiles.concat(moduleFiles(bbModuleName))

    return bowerFiles.concat projectFiles

  ###
  * @param {String} testModuleName
  ###
  prepareKarmaExclude = (testModuleName) ->
    for bbModuleName of bbDependencies
      projectFiles = projectFiles.concat(moduleSpecFiles(bbModuleName))


    projectFiles = []

    return projectFiles

  ###
  * @param {Boolean} isDev
  * @param {String} path
  ###
  getKarmaServerSettings = (isDev, modulePath) ->
    originBower = JSON.parse(fs.readFileSync(path.join(modulePath, '/bower.json'), 'utf8'))
    bbDependencies = findBBDependencies(originBower)


    moduleName = originBower.name.replace 'bookingbug-angular-', ''

    bbDependencies[moduleName] = 'master'

    serverSettings =
      configFile: path.join(__dirname, '/../karma.conf.js'),
      basePath: '../' + modulePath
      files: prepareKarmaFiles modulePath, bbDependencies
      exclude: moduleSpecFiles moduleName
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
