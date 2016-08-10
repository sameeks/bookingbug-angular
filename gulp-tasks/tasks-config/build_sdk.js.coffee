module.exports = (gulp, plugins, path) ->
  bbGulp = require('../helpers/bb-gulp.js')

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

  # ***

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

  # ***

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

  # ***

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

  # ***

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

  # ***

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

  # ***

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

  # ***

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

  # ***

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

  # ***

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
