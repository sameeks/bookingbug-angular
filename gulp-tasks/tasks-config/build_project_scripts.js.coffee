module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpCoffee = require('gulp-coffee')
  gulpConcat = require('gulp-concat')
  gulpIf = require('gulp-if');
  gulpUglify = require('gulp-uglify')
  gulpUtil = require('gulp-util')
  mainBowerFiles = require('main-bower-files')

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


  return
