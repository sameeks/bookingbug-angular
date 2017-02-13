(function () {
    'use strict';

    module.exports = function (config) {
        return config.set({
            autoWatch: true,
            browsers: ['PhantomJS'],

            babelPreprocessor: {
                options: {
                    presets: ['es2015'],
                    sourceMap: 'inline'
                },
                filename: function (file) {
                    return file.originalPath.replace(/\.js$/, '.es5.js');
                },
                sourceFileName: function (file) {
                    return file.originalPath;
                }
            },
            coverageReporter: {
                reporters: [
                    {
                        type: 'lcov',
                        dir: './test/unit/reports/coverage-lcov/',
                        file: 'lcov.info',
                        subdir: '.'
                    }
                ]
            },
            colors: true,
            frameworks: ['jasmine'],
            logLevel: config.LOG_INFO,
            port: 9876,
            preprocessors: {
                'src/*/javascripts/*.html': 'html2js',
                'src/*/javascripts/**/*.html': 'html2js',
                'src/*/javascripts/*.js': ['babel'],
                'src/*/javascripts/**/*.js': ['babel']
            },


            reporters: ['dots', 'coverage'],
            singleRun: false
        });

        /*
         coffeeCoverage: {
         preprocessor: {
         instrumentor: 'istanbul'
         }
         },
         coffeePreprocessor: {
         options: {
         bare: false,
         sourceMap: true
         },
         transformPath: function (path) {
         return path.replace(/\.coffee$/, '.js');
         }
         },
         */
        /*'src/!*!/javascripts/!(*.spec).js': ['coffee-coverage'],
            'src/!*!/javascripts/!**!/!(*.spec).js': ['coffee-coverage']*/
    };

}).call(this);
