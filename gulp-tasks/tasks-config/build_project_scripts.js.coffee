module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpCoffee = require('gulp-coffee')
  gulpConcat = require('gulp-concat')
  gulpIf = require('gulp-if');
  gulpUglify = require('gulp-uglify')
  gulpUtil = require('gulp-util')
  mainBowerFiles = require('main-bower-files')

  projectFiles = [
    path.join(args.getTestProjectRootPath(), 'src/javascripts/**/*.js')
    path.join(args.getTestProjectRootPath(), 'src/javascripts/**/*.js.coffee')
    path.join('!**/*.spec.js')
    path.join('!**/*.spec.js.coffee')
    path.join('!**/*.js.js')
    path.join('!**/*.js.map')
  ]

  ###
  * @param {Array.<String>} files
  * @param {String} filename
  ###
  buildScriptsStream = (files, filename) ->
    return gulp.src(files)
    .pipe(gulpIf(/.*js.coffee$/, gulpCoffee().on('error', gulpUtil.log)))
    .pipe(gulpConcat(filename + '.js'))
    .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))
    .pipe(gulpUglify({mangle: false}))
    .pipe(gulpConcat(filename + '.min.js'))
    .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))

  ###
  * @param {Function} filter
  * @param {String} filename
  * @returns {Object}
  ###
  buildVendorScripts = (filter, filename) ->
    dependenciesFiles = mainBowerFiles(
      paths:
        bowerDirectory: path.join args.getTestProjectRootPath(), 'bower_components'
        bowerrc: path.join args.getTestProjectRootPath(), '.bowerrc'
        bowerJson: path.join args.getTestProjectRootPath(), 'bower.json'
      filter: filter
    )

    return buildScriptsStream dependenciesFiles, filename

  ###
  * @param {String} filename
  * @returns {Object}
  ###
  buildProjectScripts = (filename) ->
    return buildScriptsStream projectFiles, filename

  ###
  * @param {String} path
  * @returns {Boolean}
  ###
  nonBbDependenciesFilter = (path) ->
    return ( path.match(new RegExp('.js$')) ) and ( path.indexOf('bookingbug-angular-') is -1 )

  ###
  * @param {String} path
  * @returns {Boolean}
  ###
  bbDependenciesFilter = (path) ->
    return ( path.match(new RegExp('.js$')) ) and ( path.indexOf('bookingbug-angular-') isnt -1 )

  gulp.task 'build-project-scripts:vendors', () ->
    return buildVendorScripts nonBbDependenciesFilter, 'vendors'

  gulp.task 'build-project-scripts:sdk', () ->
    return buildVendorScripts bbDependenciesFilter, 'sdk'

  gulp.task 'build-project-scripts:client', () ->
    return buildProjectScripts 'client'

  gulp.task 'build-project-scripts:sdk-admin:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin:javascripts'
      'build-project-scripts'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-admin-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-booking:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-admin-dashboard:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-dashboard:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-core:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:core:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-events:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:events:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-member:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:member:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-public-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:public-booking:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-services:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:services:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:sdk-settings:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:settings:javascripts'
      'build-project-scripts:sdk'
      cb
    )
    return

  gulp.task 'build-project-scripts:watch', (cb) ->
    gulp.watch(projectFiles, ['build-project-scripts:client'])

    gulp.watch(['src/admin/javascripts/**/*'], ['build-project-scripts:sdk-admin:rebuild'])
    gulp.watch(['src/admin-booking/javascripts/**/*'], ['build-project-scripts:sdk-admin-booking:rebuild'])
    gulp.watch(['src/admin-dashboard/javascripts/**/*'], ['build-project-scripts:sdk-admin-dashboard:rebuild'])
    gulp.watch(['src/core/javascripts/**/*'], ['build-project-scripts:sdk-core:rebuild'])
    gulp.watch(['src/events/javascripts/**/*'], ['build-project-scripts:sdk-events:rebuild'])
    gulp.watch(['src/member/javascripts/**/*'], ['build-project-scripts:sdk-member:rebuild'])
    gulp.watch(['src/public-booking/javascripts/**/*'], ['build-project-scripts:sdk-public-booking:rebuild'])
    gulp.watch(['src/services/javascripts/**/*'], ['build-project-scripts:sdk-services:rebuild'])
    gulp.watch(['src/settings/javascripts/**/*'], ['build-project-scripts:sdk-settings:rebuild'])

    cb()
    return


  return
