module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:admin:javascripts', () ->
    bbGulp.javascripts('admin')

  gulp.task 'build-sdk:admin:images', () ->
    bbGulp.images('admin')

  gulp.task 'build-sdk:admin:templates', () ->
    bbGulp.templates('admin')

  gulp.task 'build-sdk:admin:bower', () ->
    bbGulp.bower('admin')

  gulp.task 'build-sdk:admin', [
    'build-sdk:admin:javascripts'
    'build-sdk:admin:images'
    'build-sdk:admin:templates'
    'build-sdk:admin:bower'
  ]

  gulp.task 'build-sdk:admin:watch', () ->
    gulp.watch(['src/admin/javascripts/**/*'], ['build-sdk:admin:javascripts'])
    gulp.watch(['src/admin/images/**/*'], ['build-sdk:admin:images'])
    gulp.watch(['src/admin/templates/**/*'], ['build-sdk:admin:templates'])
