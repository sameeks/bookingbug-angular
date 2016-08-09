argv = require('yargs').argv
path = require('path')
fs = require('fs')

defaultDestPath = './build/booking-widget'
customDestSubPath = './test/projects'

getTestProjectRootPath = () ->
  if typeof argv.project isnt 'undefined'

    projectPath = path.join(customDestSubPath, argv.project);

    try
      fs.accessSync projectPath, fs.F_OK
    catch error
      console.log error
      process.exit(1)

    return projectPath

  return defaultDestPath

getTestProjectSpecsRootPath = () ->
  specRootPath = getTestProjectRootPath()
  return specRootPath.replace '/projects/', '/e2e/'

module.exports =
  getTestProjectRootPath: getTestProjectRootPath
  getTestProjectSpecsRootPath: getTestProjectSpecsRootPath




