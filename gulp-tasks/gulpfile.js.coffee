module.exports = (gulp, sdkRootPath) ->
  color = require "colors"
  gulpLoadPlugins = require("gulp-load-plugins")
  includeAll = require "include-all"
  path = require "path"

  plugins = null

  configuration =
    env: process.env.ENV_VARIABLE || "development"
    modulePath: {
      adminDashbaord: 'src/admin-dashboard'
      core: 'src/core'
      admin: 'src/admin'
      adminBooking: 'src/admin-booking'
      events: 'src/events'
      member: 'src/member'
      services: 'src/services'
      settings: 'src/settings'
      testExamples: 'src/test-examples'
    }
    sdkRootPath: sdkRootPath

  init = () ->
    loadPlugins()
    loadTasks('tasks-config')
    loadTasks('tasks-register')
    return

  loadPlugins = () ->
    plugins = gulpLoadPlugins(
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

    plugins.config = configuration
    plugins.colors = color

    return

  loadTasks = (directory) ->
    tasks = includeAll(
      dirname: path.resolve __dirname, directory
      filter: /(.+)\.(js|coffee)$/
    ) or {}

    for taskName of tasks
      plugins.error = (error)->
        plugins.util.log error.toString()
      tasks[taskName] gulp, plugins, path  if tasks.hasOwnProperty(taskName)
    return

  init()

  module.exports = gulp
