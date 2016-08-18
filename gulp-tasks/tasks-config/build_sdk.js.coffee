module.exports = (gulp, plugins, path) ->
  bbGulp = require('../helpers/bb-gulp.js')
  path = require('path')

  srcPath = path.join plugins.config.sdkRootPath, 'src'
  destPath = path.join plugins.config.sdkRootPath, 'build'

  gulp.task 'build-sdk:admin:javascripts', () ->
    bbGulp.javascripts('admin', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:admin:images', () ->
    bbGulp.images('admin', srcPath, destPath)

  gulp.task 'build-sdk:admin:templates', () ->
    bbGulp.templates('admin', srcPath, destPath)

  gulp.task 'build-sdk:admin:bower', () ->
    bbGulp.bower('admin', srcPath, destPath)

  gulp.task 'build-sdk:admin', [
    'build-sdk:admin:javascripts'
    'build-sdk:admin:images'
    'build-sdk:admin:templates'
    'build-sdk:admin:bower'
  ]

  # ***

  gulp.task 'build-sdk:admin-booking:javascripts', () ->
    bbGulp.javascripts('admin-booking', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:admin-booking:stylesheets', () ->
    bbGulp.stylesheets('admin-booking', srcPath, destPath)

  gulp.task 'build-sdk:admin-booking:templates', () ->
    bbGulp.templates('admin-booking', srcPath, destPath, 'BBAdminBooking')

  gulp.task 'build-sdk:admin-booking:bower', () ->
    bbGulp.bower('admin-booking', srcPath, destPath, 'BBAdminBooking')

  gulp.task 'build-sdk:admin-booking', [
    'build-sdk:admin-booking:javascripts'
    'build-sdk:admin-booking:stylesheets'
    'build-sdk:admin-booking:templates'
    'build-sdk:admin-booking:bower'
  ]

  # ***

  gulp.task 'build-sdk:admin-dashboard:javascripts', () ->
    bbGulp.coreJavascripts('admin-dashboard', srcPath, destPath, 'BBAdminDashboard', plugins.config.uglify)
    bbGulp.lazyJavascripts('admin-dashboard', srcPath, destPath, 'BBAdminDashboard', plugins.config.uglify)
    # bbutil.lazyJavascripts('admin-dashboard', 'BBAdminDashboard')
    # bbGulp.javascripts('admin-dashboard', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:admin-dashboard:stylesheets', () ->
    bbGulp.stylesheets('admin-dashboard', srcPath, destPath)

  gulp.task 'build-sdk:admin-dashboard:images', () ->
    bbGulp.images('admin-dashboard', srcPath, destPath)

  gulp.task 'build-sdk:admin-dashboard:templates', () ->
    return;
  #   bbGulp.templates('admin-dashboard', srcPath, destPath, false, false)

  gulp.task 'build-sdk:admin-dashboard:bower', () ->
    bbGulp.bower('admin-dashboard', srcPath, destPath)

  gulp.task 'build-sdk:admin-dashboard', [
    'build-sdk:admin-dashboard:javascripts'
    'build-sdk:admin-dashboard:stylesheets'
    'build-sdk:admin-dashboard:images'
    'build-sdk:admin-dashboard:templates'
    'build-sdk:admin-dashboard:bower'
  ]

  # ***

  gulp.task 'build-sdk:core:javascripts', () ->
    bbGulp.javascripts('core', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:core:stylesheets', () ->
    bbGulp.stylesheets('core', srcPath, destPath)

  gulp.task 'build-sdk:core:templates', () ->
    bbGulp.templates('core', srcPath, destPath)

  gulp.task 'build-sdk:core:bower', () ->
    bbGulp.bower('core', srcPath, destPath)

  gulp.task 'build-sdk:core', [
    'build-sdk:core:javascripts'
    'build-sdk:core:stylesheets'
    'build-sdk:core:templates'
    'build-sdk:core:bower'
  ]

  # ***

  gulp.task 'build-sdk:events:javascripts', () ->
    bbGulp.javascripts('events', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:events:templates', () ->
    bbGulp.templates('events', srcPath, destPath)

  gulp.task 'build-sdk:events:bower', () ->
    bbGulp.bower('events', srcPath, destPath)

  gulp.task 'build-sdk:events', [
    'build-sdk:events:javascripts'
    'build-sdk:events:templates'
    'build-sdk:events:bower'
  ]

  # ***

  gulp.task 'build-sdk:member:javascripts', () ->
    bbGulp.javascripts('member', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:member:stylesheets', () ->
    bbGulp.stylesheets('member', srcPath, destPath)

  gulp.task 'build-sdk:member:templates', () ->
    bbGulp.templates('member', srcPath, destPath)

  gulp.task 'build-sdk:member:bower', () ->
    bbGulp.bower('member', srcPath, destPath)

  gulp.task 'build-sdk:member', [
    'build-sdk:member:javascripts'
    'build-sdk:member:stylesheets'
    'build-sdk:member:templates'
    'build-sdk:member:bower'
  ]

  # ***

  gulp.task 'build-sdk:public-booking:javascripts', () ->
    bbGulp.javascripts('public-booking', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:public-booking:stylesheets', () ->
    bbGulp.stylesheets('public-booking', srcPath, destPath)

  gulp.task 'build-sdk:public-booking:fonts', () ->
    bbGulp.fonts('public-booking', srcPath, destPath)

  gulp.task 'build-sdk:public-booking:images', () ->
    bbGulp.images('public-booking', srcPath, destPath)

  gulp.task 'build-sdk:public-booking:templates', () ->
    bbGulp.templates('public-booking', srcPath, destPath)

  gulp.task 'build-sdk:public-booking:bower', () ->
    bbGulp.bower('public-booking', srcPath, destPath)

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
    bbGulp.javascripts('queue', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:queue:templates', () ->
    bbGulp.templates('queue', srcPath, destPath)

  gulp.task 'build-sdk:queue:bower', () ->
    bbGulp.bower('queue', srcPath, destPath)

  gulp.task 'build-sdk:queue', [
    'build-sdk:queue:javascripts'
    'build-sdk:queue:templates'
    'build-sdk:queue:bower'
  ]

  # ***

  gulp.task 'build-sdk:services:javascripts', () ->
    bbGulp.javascripts('services', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:services:stylesheets', () ->
    bbGulp.stylesheets('services', srcPath, destPath)

  gulp.task 'build-sdk:services:templates', () ->
    bbGulp.templates('services', srcPath, destPath)

  gulp.task 'build-sdk:services:bower', () ->
    bbGulp.bower('services', srcPath, destPath)

  gulp.task 'build-sdk:services', [
    'build-sdk:services:javascripts'
    'build-sdk:services:stylesheets'
    'build-sdk:services:templates'
    'build-sdk:services:bower'
  ]

  # ***

  gulp.task 'build-sdk:settings:javascripts', () ->
    bbGulp.javascripts('settings', srcPath, destPath, plugins.config.uglify)

  gulp.task 'build-sdk:settings:templates', () ->
    bbGulp.templates('settings', srcPath, destPath)

  gulp.task 'build-sdk:settings:bower', () ->
    bbGulp.bower('settings', srcPath, destPath)

  gulp.task 'build-sdk:settings', [
    'build-sdk:settings:javascripts'
    'build-sdk:settings:templates'
    'build-sdk:settings:bower'
  ]
