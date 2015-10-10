module.exports = (config) ->
  config.set

    basePath: ''

    frameworks: ['jasmine']

    files: [
      'release/bookingbug-angular-dependencies.js'
      'src/core/javascripts/components/*.js'
      'src/*/javascripts/main.js.coffee'
      'src/core/javascripts/ie8_http_backend.js'
      'src/core/javascripts/post_message.js'
      'src/core/javascripts/schema_form_config.js.coffee'
      'src/*/javascripts/**/*.js.coffee'
    ]

    exclude: [
      'src/*/javascripts/collections/**'
    ]

    preprocessors: {
      '**/*.coffee': ['coffee']
    }

    reporters: ['progress']

    port: 9876

    colors: true

    logLevel: config.LOG_INFO

    autoWatch: true

    browsers: ['Chrome']

    singleRun: false
