module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:queue:javascripts', () ->
    bbGulp.javascripts('queue')

  gulp.task 'build-sdk:queue:templates', () ->
    bbGulp.templates('queue')

  gulp.task 'build-sdk:queue:bower', () ->
    bbGulp.bower('queue')

  gulp.task 'build-sdk:queue', [
    'build-sdk:queue:javascripts'
    'build-sdk:queue:templates'
    'build-sdk:queue:bower'
  ]

  gulp.task 'build-sdk:queue:watch', () ->
    gulp.watch(['src/queue/javascripts/**/*'], ['build-sdk:queue:javascripts'])
    gulp.watch(['src/queue/templates/**/*'], ['build-sdk:queue:templates'])
