module.exports = (gulp, plugins, path) ->
  bbGulp = require('../helpers/bb-gulp.js')

  gulp.task 'build-sdk:member:javascripts', () ->
    bbGulp.javascripts('member')

  gulp.task 'build-sdk:member:stylesheets', () ->
    bbGulp.stylesheets('member')

  gulp.task 'build-sdk:member:templates', () ->
    bbGulp.templates('member')

  gulp.task 'build-sdk:member:bower', () ->
    bbGulp.bower('member')

  gulp.task 'build-sdk:member', [
    'build-sdk:member:javascripts'
    'build-sdk:member:stylesheets'
    'build-sdk:member:templates'
    'build-sdk:member:bower'
  ]

  gulp.task 'build-sdk:member:watch', () ->
    gulp.watch(['src/member/javascripts/**/*'], ['build-sdk:member:javascripts'])
    gulp.watch(['src/member/stylesheets/**/*'], ['build-sdk:member:stylesheets'])
    gulp.watch(['src/member/templates/**/*'], ['build-sdk:member:templates'])
