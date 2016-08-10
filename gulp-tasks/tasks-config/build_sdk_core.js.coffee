module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:core:javascripts', () ->
    bbGulp.javascripts('core')

  gulp.task 'build-sdk:core:stylesheets', () ->
    bbGulp.stylesheets('core')

  gulp.task 'build-sdk:core:templates', () ->
    bbGulp.templates('core')

  gulp.task 'build-sdk:core:bower', () ->
    bbGulp.bower('core')

  gulp.task 'build-sdk:core', [
    'build-sdk:core:javascripts'
    'build-sdk:core:stylesheets'
    'build-sdk:core:templates'
    'build-sdk:core:bower'
  ]

  gulp.task 'build-sdk:core:watch', () ->
    gulp.watch(['src/core/javascripts/**/*'], ['build-sdk:core:javascripts'])
    gulp.watch(['src/core/stylesheets/**/*'], ['build-sdk:core:stylesheets'])
    gulp.watch(['src/core/templates/**/*'], ['build-sdk:core:templates'])
