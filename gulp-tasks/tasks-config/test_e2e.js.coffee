module.exports = (gulp, plugins, path)->
  args = require '../helpers/args.js'
  protractor = require 'gulp-protractor'
  sauceConnectLauncher = require 'sauce-connect-launcher'

  launchSauceConnect = (cb) ->
    sauceConnectLauncher
      username: 'bookingbug-angular',
      accessKey: process.env.SAUCELABS_SECRET
      cb
    return

  gulp.task 'test-e2e:prepare', if process.env.TRAVIS then launchSauceConnect else protractor.webdriver_update

  gulp.task 'test-e2e:run', () ->
    return gulp.src [
      path.join args.getTestProjectSpecsRootPath(), '**/*.spec.js.coffee'
    ]
    .pipe protractor.protractor configFile: 'gulp-tasks/protractor.conf.js'
    .on 'end', () ->
      process.exit 0
      return
    .on 'error', (message) ->
      console.error message
      process.exit 1
      return

  return
