module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpFlatten = require('gulp-flatten')

  gulp.task 'build-project-images', () ->
    src = path.join args.getTestProjectRootPath(), 'src/images/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist/images'

    return gulp.src(src)
    .pipe(gulpFlatten())
    .pipe(gulp.dest(dist))

  gulp.task 'build-project-images:sdk-admin:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin:images'
      'build-project-images'
      cb
    )
    return

  gulp.task 'build-project-images:sdk-admin-dashboard:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-dashboard:images'
      'build-project-images'
      cb
    )
    return

  gulp.task 'build-project-images:sdk-public-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:public-booking:images'
      'build-project-images'
      cb
    )
    return

  gulp.task 'build-project-images:watch', (cb) ->
    imagesSrcGlob = path.join args.getTestProjectRootPath(), 'src/images/*.*'
    gulp.watch(imagesSrcGlob, ['build-project-images'])

    gulp.watch(['src/admin/images/**/*'], ['build-project-images:sdk-admin:rebuild'])
    gulp.watch(['src/admin-dashboard/images/**/*'], ['build-project-images:sdk-admin-dashboard:rebuild'])
    gulp.watch(['src/public-booking/images/**/*'], ['build-project-images:sdk-public-booking:rebuild'])

    cb()
    return

  return
