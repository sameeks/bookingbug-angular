module.exports = (config) ->

  config.set

    autoWatch: true

    basePath: '../'

    browsers: ['PhantomJS']

    coffeeCoverage: {
      preprocessor: {
        instrumentor: 'istanbul'
      }
    }

    coffeePreprocessor:
      options:
        bare: false
        sourceMap: true

      transformPath: (path) ->
        path.replace /\.coffee$/, '.js'

    coverageReporter:
      reporters: [
        {
          type: 'lcov'
          dir: './unit-tests/reports/coverage-lcov/'
          file: 'lcov.info'
          subdir: '.'
        }
      ]

    colors: true

    frameworks: ['jasmine']

    logLevel: config.LOG_INFO

    port: 9876

    preprocessors: {
      '../*/javascripts/*.html': 'html2js'
      '../*/javascripts/**/*.html': 'html2js'
      '../*/javascripts/*.spec.js.coffee': ['coffee']
      '../*/javascripts/**/*.spec.js.coffee': ['coffee']
      '../*/javascripts/!(*.spec).js.coffee': ['coffee-coverage']
      '../*/javascripts/**/!(*.spec).js.coffee': ['coffee-coverage']
    }

    reporters: ['dots', 'coverage']

    singleRun: false
