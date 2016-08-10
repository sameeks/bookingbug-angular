module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:admin-dashboard:javascripts', () ->
    bbGulp.javascripts('admin-dashboard')

  gulp.task 'build-sdk:admin-dashboard:stylesheets', () ->
    bbGulp.stylesheets('admin-dashboard')

  gulp.task 'build-sdk:admin-dashboard:images', () ->
    bbGulp.images('admin-dashboard')

  gulp.task 'build-sdk:admin-dashboard:templates', () ->
    bbGulp.templates('admin-dashboard')

  gulp.task 'build-sdk:admin-dashboard:bower', () ->
    bbGulp.bower('admin-dashboard')

  gulp.task 'build-sdk:admin-dashboard', [
    'build-sdk:admin-dashboard:javascripts'
    'build-sdk:admin-dashboard:stylesheets'
    'build-sdk:admin-dashboard:images'
    'build-sdk:admin-dashboard:templates'
    'build-sdk:admin-dashboard:bower'
  ]

  gulp.task 'build-sdk:admin-dashboard:watch', () ->
    gulp.watch(['src/admin-dashboard/javascripts/**/*'], ['build-sdk:admin-dashboard:javascripts'])
    gulp.watch(['src/admin-dashboard/stylesheets/**/*'], ['build-sdk:admin-dashboard:stylesheets'])
    gulp.watch(['src/admin-dashboard/images/**/*'], ['build-sdk:admin-dashboard:images'])
    gulp.watch(['src/admin-dashboard/templates/**/*'], ['build-sdk:admin-dashboard:templates'])
