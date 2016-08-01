module.exports = (gulp, plugins, growl, path)->
  fs = require('fs')
  jsonFile = require('jsonfile')

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

    jsonFile.writeFile subModulePath + '/unit-tests/bower.json', originBower, (err) ->
      console.log err if err isnt null

    return

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
