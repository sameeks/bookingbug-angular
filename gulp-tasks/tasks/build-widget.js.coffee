module.exports = (gulp, plugins, path) ->

  mainBowerFiles = require('main-bower-files')
  concat = require('gulp-concat')
  uglify = require('gulp-uglify')
  sourcemaps = require('gulp-sourcemaps')
  plumber = require('gulp-plumber')
  sass = require('gulp-sass')
  cssSelectorLimit = require('gulp-css-selector-limit')
  bower = require('gulp-bower')
  args = require('../args.js')

  gulp.task 'bower-widget', () ->
    bower({cwd: args.getTestProjectRootPath(), directory: './bower_components'})
    return

  gulp.task 'build:widget-script', () ->
    gulp.src(mainBowerFiles(
      filter: new RegExp('.js$')
      paths:
        bowerDirectory: path.join(args.getTestProjectRootPath(),'bower_components')
        bowerJson: path.join(args.getTestProjectRootPath(), 'bower.json')
    ))
      .pipe(concat('booking-widget.js'))
      .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))
      .pipe(uglify({mangle: false}))
      .pipe(concat('booking-widget.min.js'))
      .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))

  gulp.task 'build:widget-style', () ->
    gulp.src(path.join(args.getTestProjectRootPath(),'src/stylesheets/main.scss'))
      .pipe(sourcemaps.init())
      .pipe(plumber())
      .pipe(sass(
        includePaths: [path.join(args.getTestProjectRootPath(),'bower_components/bootstrap-sass/assets/stylesheets')]
        outputStyle: 'compressed'
        errLogToConsole: true
      ))
      .pipe(concat('booking-widget.css'))
      .pipe(cssSelectorLimit.reporter('fail'))
      .pipe(sourcemaps.write('maps', { includeContent: false }))
      .pipe(gulp.dest(path.join(args.getTestProjectRootPath(),'dist')))

  filterStylesheets = (path) ->
    path.match(new RegExp('.css$')) &&
    !path.match(new RegExp('(bower_components\/bookingbug-angular-).+(\.css)')) &&
    path.indexOf('bootstrap.') == -1

  gulp.task 'build:widget-dependency-style', () ->
    gulp.src(mainBowerFiles(
      includeDev: true
      filter: filterStylesheets
      paths:
        bowerDirectory: path.join(args.getTestProjectRootPath(), 'bower_components')
        bowerJson: path.join(args.getTestProjectRootPath(), 'bower.json')
    ))
      .pipe(concat('booking-widget-dependencies.css'))
      .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))

  gulp.task 'build:widget', [
    'build'
    'bower-widget'
    'build:widget-script'
    'build:widget-style'
    'build:widget-dependency-style'
  ]

