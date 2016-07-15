exports.config =
  specs: ['../e2e-tests/**/*.spec.js.coffee'],
  capabilities:
    browserName: 'chrome'

if process.env.TRAVIS
  exports.config.sauceUser = 'bookingbug-angular'
  exports.config.sauceKey = process.env.SAUCELABS_SECRET
  exports.config.sauceSeleniumAddress = 'localhost:4445/wd/hub'
else
  exports.config.seleniumServerJar = '../node_modules/selenium-server-standalone-jar/jar/selenium-server-standalone-2.53.0.jar'


