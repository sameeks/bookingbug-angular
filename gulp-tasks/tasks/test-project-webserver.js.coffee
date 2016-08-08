module.exports = (gulp, plugins, path)->
  gulpConnect = require('gulp-connect')
  args = require('../args.js')
  del = require('del')
  open = require('gulp-open')
  flatten = require('gulp-flatten')
  fs = require('fs')
  mainBowerFiles = require('main-bower-files')
  gulpTemplate = require('gulp-template')
  jsonFile = require('jsonfile')
  sourcemaps = require('gulp-sourcemaps')
  gutil = require('gulp-util')
  sass = require('gulp-sass')
  plumber = require('gulp-plumber')
  cssSelectorLimit = require('gulp-css-selector-limit')
  concat = require('gulp-concat')
  streamqueue = require('streamqueue')

  config = null

  gulp.task 'test-project:config', () ->
    src = path.join args.getTestProjectRootPath(), 'config.json'
    config = jsonFile.readFileSync(src);
    configEnv = 'development'

    if plugins.config.env.match /stag/
      configEnv = 'staging'
    else if plugins.config.env.match /prod/
      configEnv = 'production'

    for prop, propValue of config[configEnv]
      config[prop] = propValue

    delete config['development']
    delete config['staging']
    delete config['production']

    return

  gulp.task 'test-project:clean-dist', (cb) ->
    src = path.join args.getTestProjectRootPath(), 'dist'
    del.sync([src])
    cb()
    return

  gulp.task 'test-project:images', () ->
    src = path.join args.getTestProjectRootPath(), 'src/images/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist/images'

    return gulp.src(src)
    .pipe(flatten())
    .pipe(gulp.dest(dist))

  gulp.task 'test-project:fonts', () ->
    src = path.join args.getTestProjectRootPath(), 'src/fonts/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist/fonts'

    dependenciesFontFiles = mainBowerFiles {
      includeDev: true,
      paths:
        bowerDirectory: path.join args.getTestProjectRootPath(), 'bower_components'
        bowerrc: path.join args.getTestProjectRootPath(), '.bowerrc'
        bowerJson: path.join args.getTestProjectRootPath(), 'bower.json'
      filter: '**/*.{eot,svg,ttf,woff,woff2,otf}'
    }

    return gulp.src(dependenciesFontFiles.concat src)
    .pipe(flatten())
    .pipe(gulp.dest(dist))

  gulp.task 'test-project:www', ['test-project:config'], () ->
    src = path.join args.getTestProjectRootPath(), 'src/www/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist'

    return gulp.src(src)
    .pipe(gulpTemplate(config))
    .pipe(gulp.dest(dist))

  gulp.task 'test-project:stylesheets', ['test-project:config'], () ->
    src = path.join args.getTestProjectRootPath(), 'src/stylesheets/main.scss'
    srcBootstrap = path.join args.getTestProjectRootPath(), 'src/stylesheets/bootstrap.scss'
    dest = path.join args.getTestProjectRootPath(), 'dist'

    dependenciesCssFiles = mainBowerFiles {
      includeDev: true,
      paths:
        bowerDirectory: path.join args.getTestProjectRootPath(), 'bower_components'
        bowerrc: path.join args.getTestProjectRootPath(), '.bowerrc'
        bowerJson: path.join args.getTestProjectRootPath(), 'bower.json'
      filter: (path) ->
        return (
          path.match(new RegExp('.css$')) and !path.match(new RegExp('(bower_components\/bookingbug-angular-).+(\.css)')) and
            path.indexOf('boostrap.') == -1
        )
    }

    dependenciesCssStream = gulp.src(dependenciesCssFiles).pipe(sourcemaps.init())

    ##TODO do we need compressed in this case
    #.pipe(sass({outputStyle: 'compressed', onError: (e) -> console.log(e) }).on('error', gutil.log))

    bootstrapSCSSStream = gulp.src(srcBootstrap)
    .pipe(sourcemaps.init())
    .pipe(gulpTemplate(config))
    .pipe(sass({onError: (e) -> console.log(e)}).on('error', gutil.log))

    appSCSSStream = gulp.src(src)
    .pipe(sourcemaps.init())
    .pipe(gulpTemplate(config))
    .pipe(sass({onError: (e) -> console.log(e)}).on('error', gutil.log))

    return streamqueue({objectMode: true}, bootstrapSCSSStream, dependenciesCssStream, appSCSSStream)
    .pipe(plumber())
    .pipe(flatten())
    .pipe(concat('app.css'))
    .pipe(cssSelectorLimit.reporter('fail'))
    .pipe(sourcemaps.write('maps', {includeContent: false}))
    .pipe(gulp.dest(dest))

  gulp.task 'test-project:webserver', () ->
    gulpConnect.server {
      root: [
        path.join args.getTestProjectRootPath(), 'dist'
      ]
      port: 8000
      livereload: true
    }

    return

  gulp.task 'test-project:assets', [
    'test-project:images',
    'test-project:www',
    'test-project:fonts',
    'test-project:stylesheets'
  ], () ->
    return

  #['assets', 'html-files-in-www-folder', 'watch', 'webserver'],
  gulp.task 'default', [
    'test-project:clean-dist',
    'build:widget',
    'test-project:assets'
    'test-project:webserver'
  ], () ->
    return
