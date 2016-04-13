exports.config = {
  seleniumServerJar: '../node_modules/selenium-server-standalone-jar/jar/selenium-server-standalone-2.53.0.jar',
  specs: ['booking.js.coffee'],
  capabilities: {
    browserName: process.env.TRAVIS ? 'phantomjs' : 'chrome',
    'phantomjs.binary.path': require('phantomjs-prebuilt').path 
  }
};
