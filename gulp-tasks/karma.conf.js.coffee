module.exports = (config) ->

  config.set

    autoWatch: true

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
          dir: './unit-tests-reports/coverage-lcov/'
          file: 'lcov.info'
          subdir: '.'
        }
      ]

    colors: true

    exclude: [
      'javascripts/collections/**'
    ]

    frameworks: ['jasmine']

    logLevel: config.LOG_INFO

    port: 9876

    preprocessors: {
      '**/*.html': 'html2js'
      '*.html': 'html2js'
      '*.spec.js.coffee': ['coffee']
      '!(*.spec).js.coffee': ['coffee-coverage']
      '**/*.spec.js.coffee': ['coffee']
      '**/!(*.spec).js.coffee': ['coffee-coverage']
    }

    reporters: ['dots', 'coverage']

    singleRun: false
