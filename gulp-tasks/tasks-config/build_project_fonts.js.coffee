module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpFlatten = require('gulp-flatten')
  mainBowerFiles = require('main-bower-files')

  gulp.task 'build-project-fonts', () ->
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

  gulp.task 'build-project-fonts:watch', (cb) ->
    fontsSrcGlob = path.join args.getTestProjectRootPath(), 'src/fonts/*.*'
    gulp.watch(fontsSrcGlob, ['build-project-fonts'])

    gulp.watch(['src/public-booking/fonts/**/*'], ['build-sdk:public-booking:fonts'])

    ###gulp.watch([
      path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-* /**'
      '!' + path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-* /** /*.{jpg,gif,png,bmp}'
      '!' + path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-* /** /*.js'
      '!' + path.join args.getTestProjectRootPath(), 'bower_components/bookingbug-angular-* /** /*.scss'
    ], [''])###

    cb()
    return

  return
