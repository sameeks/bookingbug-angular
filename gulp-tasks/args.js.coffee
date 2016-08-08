argv = require('yargs').argv
path = require('path')
fs = require('fs')

defaultDestPath = './test/projects/booking-widget'
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

module.exports =
  getTestProjectRootPath: getTestProjectRootPath




