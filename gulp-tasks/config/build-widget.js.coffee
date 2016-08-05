module.exports = (gulp, plugins, path) ->

  mainBowerFiles = require('main-bower-files')
  concat = require('gulp-concat')
  uglify = require('gulp-uglify')
  sourcemaps = require('gulp-sourcemaps')
  plumber = require('gulp-plumber')
  sass = require('gulp-sass')
  cssSelectorLimit = require('gulp-css-selector-limit')
  bower = require('gulp-bower')
  argv = require('yargs').argv

  defaultDestPath = './build/booking-widget'
  customDestSubPath = './test/projects'

  getDestPath = () ->
    if typeof argv.project isnt 'undefined'
      return path.join(customDestSubPath, argv.project);
    return defaultDestPath

  gulp.task 'bower-widget', () ->
    bower({cwd: getDestPath(), directory: './bower_components'})
    return

  gulp.task 'build:widget-script', () ->
    gulp.src(mainBowerFiles(
      filter: new RegExp('.js$')
      paths:
        bowerDirectory: path.join(getDestPath(),'bower_components')
        bowerJson: path.join(getDestPath(), 'bower.json')
    ))
      .pipe(concat('booking-widget.js'))
      .pipe(gulp.dest(path.join(getDestPath(), 'dist')))
      .pipe(uglify({mangle: false}))
      .pipe(concat('booking-widget.min.js'))
      .pipe(gulp.dest(getDestPath('dist')))

  gulp.task 'build:widget-style', () ->
    gulp.src(path.join(getDestPath(),'src/stylesheets/main.scss'))
      .pipe(sourcemaps.init())
      .pipe(plumber())
      .pipe(sass(
        includePaths: [path.join(getDestPath(),'bower_components/bootstrap-sass/assets/stylesheets')]
        outputStyle: 'compressed'
        errLogToConsole: true
      ))
      .pipe(concat('booking-widget.css'))
      .pipe(cssSelectorLimit.reporter('fail'))
      .pipe(sourcemaps.write('maps', { includeContent: false }))
      .pipe(gulp.dest(path.join(getDestPath(),'dist')))

  filterStylesheets = (path) ->
    path.match(new RegExp('.css$')) &&
    !path.match(new RegExp('(bower_components\/bookingbug-angular-).+(\.css)')) &&
    path.indexOf('bootstrap.') == -1

  gulp.task 'build:widget-dependency-style', () ->
    gulp.src(mainBowerFiles(
      includeDev: true
      filter: filterStylesheets
      paths:
        bowerDirectory: path.join(getDestPath(), 'bower_components')
        bowerJson: path.join(getDestPath(), 'bower.json')
    ))
      .pipe(concat('booking-widget-dependencies.css'))
      .pipe(gulp.dest(path.join(getDestPath(), 'dist')))

  gulp.task 'build:widget', [
    'build'
    'bower-widget'
    'build:widget-script'
    'build:widget-style'
    'build:widget-dependency-style'
  ]

