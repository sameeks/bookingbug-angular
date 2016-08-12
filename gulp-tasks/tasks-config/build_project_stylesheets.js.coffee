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

  gulp.task 'build-project-stylesheets', () ->
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

    gulpSassOptions =
      onError: (e) -> console.log(e)

    if args.getEnvironment() isnt 'dev'
      gulpSassOptions.outputStyle = 'compressed'

    appSCSSStream = gulp.src(src)
    .pipe(gulpSourcemaps.init())
    .pipe(gulpTemplate(projectConfig.getConfig()))
    .pipe(gulpSass(gulpSassOptions).on('error', gulpUtil.log))


    return streamqueue({objectMode: true}, dependenciesCssStream, appSCSSStream)
    .pipe(gulpPlumber())
    .pipe(gulpFlatten())
    .pipe(gulpConcat('styles.css'))
    .pipe(gulpCssSelectorLimit.reporter('fail'))
    .pipe(gulpSourcemaps.write('maps', {includeContent: false}))
    .pipe(gulp.dest(dest))

  gulp.task 'build-project-stylesheets:watch', (cb) ->
    src = path.join args.getTestProjectRootPath(), 'src/stylesheets/main.scss'
    gulp.watch(src, ['build-project-stylesheets'])

    gulp.watch(['src/admin-booking/stylesheets/**/*'], ['build-sdk:admin-booking:stylesheets'])
    gulp.watch(['src/admin-dashboard/stylesheets/**/*'], ['build-sdk:admin-dashboard:stylesheets'])
    gulp.watch(['src/core/stylesheets/**/*'], ['build-sdk:core:stylesheets'])
    gulp.watch(['src/member/stylesheets/**/*'], ['build-sdk:member:stylesheets'])
    gulp.watch(['src/public-booking/stylesheets/**/*'], ['build-sdk:public-booking:stylesheets'])

    gulp.watch([path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-*/**/*.scss'], ['build-project-stylesheets'])

    cb()
    return

  return
