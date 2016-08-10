module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpFlatten = require('gulp-flatten')

  gulp.task 'build-project:images', () ->
    src = path.join args.getTestProjectRootPath(), 'src/images/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist/images'

    return gulp.src(src)
    .pipe(gulpFlatten())
    .pipe(gulp.dest(dist))

  return
