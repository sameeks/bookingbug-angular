module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:settings:javascripts', () ->
    bbGulp.javascripts('settings')

  gulp.task 'build-sdk:settings:templates', () ->
    bbGulp.templates('settings')

  gulp.task 'build-sdk:settings:bower', () ->
    bbGulp.bower('settings')

  gulp.task 'build-sdk:settings', [
    'build-sdk:settings:javascripts'
    'build-sdk:settings:templates'
    'build-sdk:settings:bower'
  ]

  gulp.task 'build-sdk:settings:watch', ['build-sdk:settings'], () ->
    gulp.watch(['src/settings/javascripts/**/*'], ['build-sdk:settings:javascripts'])
    gulp.watch(['src/settings/templates/**/*'], ['build-sdk:settings:templates'])
