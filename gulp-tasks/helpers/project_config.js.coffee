path = require('path')
fs = require('fs')
args = require('./args.js')
jsonFile = require('jsonfile')

getConfig = () ->
  env = args.getEnvironment()
  config = null
  configPath = path.join args.getTestProjectRootPath(), 'config.json'

  try
    config = jsonFile.readFileSync(configPath);
  catch error
    console.log 'No config file specified for project'
    return {}

  configProperty = 'development'

  if env.match /stag/
    configProperty = 'staging'
  else if env.match /prod/
    configProperty = 'production'

  for prop, propValue of config[configProperty]
    config[prop] = propValue

  delete config['development']
  delete config['staging']
  delete config['production']

  return config

module.exports =
  getConfig: getConfig
