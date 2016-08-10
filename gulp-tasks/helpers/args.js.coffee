argv = require('yargs').argv
path = require('path')
fs = require('fs')

defaultDestPath = './build/booking-widget'
customDestSubPath = './test/projects'

###
* @returns {String} ['dev'|'staging'|'prod']
###
getEnvironment = () ->
  environment = 'dev'
  environmentOptions = ['dev', 'staging', 'prod']
  if typeof argv.env isnt 'undefined'
    if environmentOptions.indexOf(argv.env) is -1
      console.log 'env can has one of following values: ' + environmentOptions
      process.exit 1
    environment = argv.env
  return environment

###
* @returns {String} ['dev'|'staging'|'prod']
###
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

###
* @returns {String} ['dev'|'staging'|'prod']
###
getTestProjectSpecsRootPath = () ->
  specRootPath = getTestProjectRootPath()
  return specRootPath.replace '/projects/', '/e2e/'

module.exports =
  getEnvironment: getEnvironment
  getTestProjectRootPath: getTestProjectRootPath
  getTestProjectSpecsRootPath: getTestProjectSpecsRootPath




