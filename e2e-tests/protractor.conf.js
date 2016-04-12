exports.config = {
  seleniumServerJar: '../node_modules/selenium-server-standalone-jar/jar/selenium-server-standalone-2.53.0.jar',
  specs: ['booking.js.coffee'],
  capatibilities: {
    browserName: 'chrome',
    'chrome-switches': ['--no-sandbox'] 
  }
};
