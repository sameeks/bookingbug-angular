growl = false

loadTasks = (path)->
  includeAll(
    dirname: require("path").resolve __dirname, path
    filter: /(.+)\.(js|coffee)$/
  ) or {}

invokeConfigFn = (tasks) ->
  for taskName of tasks
    plugins.error = (error)->
      plugins.util.log error.toString()
    tasks[taskName] gulp, plugins, growl, path  if tasks.hasOwnProperty(taskName)

gulp = require "gulp"
plugins = require("gulp-load-plugins")(
  pattern: [
    "gulp-*"
    "merge-*"
    "run-*"
    "main*"
    "karma*"
  ]
  replaceString: /\bgulp[\-.]|run[\-.]|merge[\-.]|main[\-.]/
  camelizePluginName: true
  lazy: true
)

plugins.config =
  destPath: "./tmp/"
  env: process.env.ENV_VARIABLE || "development"
plugins.colors = require "colors"

path = require "path"
includeAll = require "include-all"

taskConfigurations = loadTasks "./config"
registerDefinitions = loadTasks "./register"

if not registerDefinitions['default.js']
  registerDefinitions.default = (gulp)->
    gulp.task 'default', []

invokeConfigFn taskConfigurations
invokeConfigFn registerDefinitions

module.exports = gulp
