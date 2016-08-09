module.exports = (gulp, plugins, path)->
  gulpCoffee = require('gulp-coffee')
  args = require('../args.js')
  del = require('del')
  gulpUglify = require('gulp-uglify')
  gulpFlatten = require('gulp-flatten')
  fs = require('fs')
  gulpBower = require('gulp-bower')
  mainBowerFiles = require('main-bower-files')
  gulpTemplate = require('gulp-template')
  jsonFile = require('jsonfile')
  gulpSourcemaps = require('gulp-sourcemaps')
  gulpUtil = require('gulp-util')
  gulpSass = require('gulp-sass')
  gulpPlumber = require('gulp-plumber')
  gulpCssSelectorLimit = require('gulp-css-selector-limit')
  gulpConcat = require('gulp-concat')
  streamqueue = require('streamqueue')
  mkdirp = require('mkdirp')
  gulpIf = require('gulp-if');

  config = null

  gulp.task 'build-project:clean', (cb) ->
    distPath = path.join args.getTestProjectRootPath(), 'dist'
    del.sync([distPath])
    cb()
    return

  gulp.task 'build-project:config', (cb) ->
    configPath = path.join args.getTestProjectRootPath(), 'config.json'

    try
      config = jsonFile.readFileSync(configPath);
    catch error
      console.log 'No config file specified for project'
      return

    if config is null
      config = {}
      return

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

    cb()

    return

  gulp.task 'build-project:install-bower', () ->
    mkdirp.sync(path.join args.getTestProjectRootPath(), 'bower_components');
    return gulpBower({cwd: args.getTestProjectRootPath(), directory: './bower_components'})

  gulp.task 'build-project:scripts', () ->
    dependenciesFiles = mainBowerFiles(
      filter: new RegExp('.js$')
      paths:
        bowerDirectory: path.join args.getTestProjectRootPath(), 'bower_components'
        bowerrc: path.join args.getTestProjectRootPath(), '.bowerrc'
        bowerJson: path.join args.getTestProjectRootPath(), 'bower.json'
    )

    projectFiles = [
      path.join(args.getTestProjectRootPath(), 'src/javascripts/**/*.js')
      path.join(args.getTestProjectRootPath(), 'src/javascripts/**/*.js.coffee')
      path.join('!**/*.spec.js')
      path.join('!**/*.spec.js.coffee')
      path.join('!**/*.js.js')
      path.join('!**/*.js.map')
    ]

    gulp.src(dependenciesFiles.concat projectFiles)
    .pipe(gulpIf(/.*js.coffee$/, gulpCoffee().on('error', gulpUtil.log)))
    .pipe(gulpConcat('scripts.js'))
    .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))
    .pipe(gulpUglify({mangle: false}))
    .pipe(gulpConcat('scripts.min.js'))
    .pipe(gulp.dest(path.join(args.getTestProjectRootPath(), 'dist')))

  gulp.task 'build-project:stylesheets', ['build-project:config'], () ->
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
    .pipe(gulpTemplate(config))
    .pipe(gulpSass({onError: (e) -> console.log(e)}).on('error', gulpUtil.log))

    return streamqueue({objectMode: true}, dependenciesCssStream, appSCSSStream)
    .pipe(gulpPlumber())
    .pipe(gulpFlatten())
    .pipe(gulpConcat('styles.css'))
    .pipe(gulpCssSelectorLimit.reporter('fail'))
    .pipe(gulpSourcemaps.write('maps', {includeContent: false}))
    .pipe(gulp.dest(dest))

  gulp.task 'build-project:fonts', () ->
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
    .pipe(gulpFlatten())
    .pipe(gulp.dest(dist))

  gulp.task 'build-project:images', () ->
    src = path.join args.getTestProjectRootPath(), 'src/images/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist/images'

    return gulp.src(src)
    .pipe(gulpFlatten())
    .pipe(gulp.dest(dist))

  gulp.task 'build-project:www', ['build-project:config'], () ->
    src = path.join args.getTestProjectRootPath(), 'src/www/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist'

    return gulp.src(src)
    .pipe(gulpTemplate(config))
    .pipe(gulp.dest(dist))

  #['assets', 'html-files-in-www-folder', 'watch', 'webserver'],
  gulp.task 'build-project', (cb) ->
    plugins.sequence(
      'build-project:clean'
      'build-sdk'
      'build-project:install-bower'
      [
        'build-project:scripts'
        'build-project:stylesheets'
        'build-project:fonts'
        'build-project:images'
        'build-project:www'
      ]
      cb
    )
    return

  return
