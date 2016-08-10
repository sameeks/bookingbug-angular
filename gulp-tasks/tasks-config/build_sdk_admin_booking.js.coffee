module.exports = (gulp, plugins, path) ->
  bbGulp = require('../helpers/bb-gulp.js')

  gulp.task 'build-sdk:admin-booking:javascripts', () ->
    bbGulp.javascripts('admin-booking')

  gulp.task 'build-sdk:admin-booking:stylesheets', () ->
    bbGulp.stylesheets('admin-booking')

  gulp.task 'build-sdk:admin-booking:templates', () ->
    bbGulp.templates('admin-booking')

  gulp.task 'build-sdk:admin-booking:bower', () ->
    bbGulp.bower('admin-booking')

  gulp.task 'build-sdk:admin-booking', [
    'build-sdk:admin-booking:javascripts'
    'build-sdk:admin-booking:stylesheets'
    'build-sdk:admin-booking:templates'
    'build-sdk:admin-booking:bower'
  ]

  gulp.task 'build-sdk:admin-booking:watch', () ->
    gulp.watch(['src/admin-booking/javascripts/**/*'], ['build-sdk:admin-booking:javascripts'])
    gulp.watch(['src/admin-booking/stylesheets/**/*'], ['build-sdk:admin-booking:stylesheets'])
    gulp.watch(['src/admin-booking/templates/**/*'], ['build-sdk:admin-booking:templates'])
