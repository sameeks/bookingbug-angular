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

  gulp.task 'test-unit:bower-prepare', (cb)->
    nonBBDependencies = {}

    testBowerJson = JSON.parse(fs.readFileSync('test/unit/bower.json', 'utf8'))

    orderedSubModulesNames = [
      'core'
      'admin'
      'admin-booking'
      'events'
      'member'
      'services'
      'settings'
      'test-examples'
      'admin-dashboard'
    ]

    for subModuleName in orderedSubModulesNames
      bowerJson = JSON.parse(fs.readFileSync(path.join('src', subModuleName, '/bower.json'), 'utf8'))

      for depName,depVersion of bowerJson.dependencies
        if not isBBDependency depName
          nonBBDependencies[depName] = depVersion

    testBowerJson.name         = 'bb-unit-test'
    testBowerJson.dependencies = nonBBDependencies

    mkDirP.sync 'test/unit'
    jsonFile.writeFile 'test/unit/bower.json', testBowerJson, (err) ->
      console.log err if err isnt null

    cb()
    return

  return
