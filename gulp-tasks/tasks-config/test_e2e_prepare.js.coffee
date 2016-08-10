module.exports = (gulp, plugins, path)->
  protractor = require 'gulp-protractor'
  sauceConnectLauncher = require 'sauce-connect-launcher'

  launchSauceConnect = (cb) ->
    sauceConnectLauncher
      username: 'bookingbug-angular',
      accessKey: process.env.SAUCELABS_SECRET
      cb
    return

  gulp.task 'test-e2e:prepare', if process.env.TRAVIS then launchSauceConnect else protractor.webdriver_update

  return
