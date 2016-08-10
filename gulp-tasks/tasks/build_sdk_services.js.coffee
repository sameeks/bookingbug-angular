module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:services:javascripts', () ->
    bbGulp.javascripts('services')

  gulp.task 'build-sdk:services:templates', () ->
    bbGulp.templates('services')

  gulp.task 'build-sdk:services:bower', () ->
    bbGulp.bower('services')

  gulp.task 'build-sdk:services', [
    'build-sdk:services:javascripts'
    'build-sdk:services:templates'
    'build-sdk:services:bower'
  ]

  gulp.task 'build-sdk:services:watch', ['build-sdk:services'], () ->
    gulp.watch(['src/services/javascripts/**/*'], ['build-sdk:services:javascripts'])
    gulp.watch(['src/services/templates/**/*'], ['build-sdk:services:templates'])
