module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpFlatten = require('gulp-flatten')
  gulpConcat = require('gulp-concat')
  gulpCssSelectorLimit = require('gulp-css-selector-limit')
  gulpPlumber = require('gulp-plumber')
  gulpTemplate = require('gulp-template')
  gulpSass = require('gulp-sass')
  gulpSourcemaps = require('gulp-sourcemaps')
  gulpUtil = require('gulp-util')
  mainBowerFiles = require('main-bower-files')
  projectConfig = require('../helpers/project_config.js')
  streamqueue = require('streamqueue')

  gulp.task 'build-project:stylesheets', () ->
    src = path.join args.getTestProjectRootPath(), 'src/stylesheets/main.scss'
    dest = path.join args.getTestProjectRootPath(), 'dist'

    dependenciesCssFiles = mainBowerFiles {
      includeDev: true,
      paths:
        bowerDirectory: path.join args.getTestProjectRootPath(), 'bower_components'
        bowerrc: path.join args.getTestProjectRootPath(), '.bowerrc'
        bowerJson: path.join args.getTestProjectRootPath(), 'bower.json'
      filter: (path) ->
        return (
          path.match(
            new RegExp('.css$')) and !path.match(new RegExp('(bower_components\/bookingbug-angular-).+(\.css)')) and
            path.indexOf('boostrap.') == -1
        )
    }

    dependenciesCssStream = gulp.src(dependenciesCssFiles).pipe(gulpSourcemaps.init())

    ##TODO do we need compressed in this case
    #.pipe(gulpSass({outputStyle: 'compressed', onError: (e) -> console.log(e) }).on('error', gulpUtil.log))

    appSCSSStream = gulp.src(src)
    .pipe(gulpSourcemaps.init())
    .pipe(gulpTemplate(projectConfig.getConfig()))
    .pipe(gulpSass({onError: (e) -> console.log(e)}).on('error', gulpUtil.log))

    return streamqueue({objectMode: true}, dependenciesCssStream, appSCSSStream)
    .pipe(gulpPlumber())
    .pipe(gulpFlatten())
    .pipe(gulpConcat('styles.css'))
    .pipe(gulpCssSelectorLimit.reporter('fail'))
    .pipe(gulpSourcemaps.write('maps', {includeContent: false}))
    .pipe(gulp.dest(dest))

  gulp.task 'build-project:stylesheets:sdk-admin-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-booking:stylesheets'
      'build-project:stylesheets'
      cb
    )
    return

  gulp.task 'build-project:templates:sdk-admin-dashboard:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-dashboard:templates'
      'build-project:templates'
      cb
    )
    return

  gulp.task 'build-project:stylesheets:sdk-core:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:core:stylesheets'
      'build-project:stylesheets'
      cb
    )
    return

  gulp.task 'build-project:stylesheets:sdk-member:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:member:stylesheets'
      'build-project:stylesheets'
      cb
    )
    return

  gulp.task 'build-project:stylesheets:sdk-public-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:public-booking:stylesheets'
      'build-project:stylesheets'
      cb
    )
    return

  gulp.task 'build-project:stylesheets:watch', (cb) ->

    src = path.join args.getTestProjectRootPath(), 'src/stylesheets/main.scss'
    gulp.watch(src, ['build-project:stylesheets'])

    gulp.watch(['src/admin-booking/stylesheets/**/*'], ['build-project:stylesheets:sdk-admin-booking:rebuild'])
    gulp.watch(['src/admin-dashboard/stylesheets/**/*'], ['build-project:stylesheets:sdk-admin-dashboard:rebuild'])
    gulp.watch(['src/core/stylesheets/**/*'], ['build-project:stylesheets:sdk-core:rebuild'])
    gulp.watch(['src/member/stylesheets/**/*'], ['build-project:stylesheets:sdk-member:rebuild'])
    gulp.watch(['src/public-booking/stylesheets/**/*'], ['build-project:stylesheets:sdk-public-booking:rebuild'])

    cb()
    return


  return
