module.exports = (gulp, plugins, path) ->
  bbGulp = require('../bb-gulp.js')

  gulp.task 'build-sdk:public-booking:javascripts', () ->
    bbGulp.javascripts('public-booking')

  gulp.task 'build-sdk:public-booking:stylesheets', () ->
    bbGulp.stylesheets('public-booking')

  gulp.task 'build-sdk:public-booking:fonts', () ->
    bbGulp.fonts('public-booking')

  gulp.task 'build-sdk:public-booking:images', () ->
    bbGulp.images('public-booking')

  gulp.task 'build-sdk:public-booking:templates', () ->
    bbGulp.templates('public-booking')

  gulp.task 'build-sdk:public-booking:bower', () ->
    bbGulp.bower('public-booking')

  gulp.task 'build-sdk:public-booking', [
    'build-sdk:public-booking:javascripts'
    'build-sdk:public-booking:stylesheets'
    'build-sdk:public-booking:fonts'
    'build-sdk:public-booking:images'
    'build-sdk:public-booking:templates'
    'build-sdk:public-booking:bower'
  ]

  gulp.task 'build-sdk:public-booking:watch', () ->
    gulp.watch(['src/public-booking/javascripts/**/*'], ['build-sdk:public-booking:javascripts'])
    gulp.watch(['src/public-booking/stylesheets/**/*'], ['build-sdk:public-booking:stylesheets'])
    gulp.watch(['src/public-booking/fonts/**/*'], ['build-sdk:public-booking:fonts'])
    gulp.watch(['src/public-booking/images/**/*'], ['build-sdk:public-booking:images'])
    gulp.watch(['src/public-booking/templates/**/*'], ['build-sdk:public-booking:templates'])
