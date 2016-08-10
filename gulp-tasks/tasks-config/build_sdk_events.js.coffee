module.exports = (gulp, plugins, path) ->
  bbGulp = require('../helpers/bb-gulp.js')

  gulp.task 'build-sdk:events:javascripts', () ->
    bbGulp.javascripts('events')

  gulp.task 'build-sdk:events:templates', () ->
    bbGulp.templates('events')

  gulp.task 'build-sdk:events:bower', () ->
    bbGulp.bower('events')

  gulp.task 'build-sdk:events', [
    'build-sdk:events:javascripts'
    'build-sdk:events:templates'
    'build-sdk:events:bower'
  ]

  gulp.task 'build-sdk:events:watch', () ->
    gulp.watch(['src/events/javascripts/**/*'], ['build-sdk:events:javascripts'])
    gulp.watch(['src/events/templates/**/*'], ['build-sdk:events:templates'])
