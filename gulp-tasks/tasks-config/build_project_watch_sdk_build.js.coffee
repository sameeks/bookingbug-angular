module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')

  gulp.task 'build-project:watch-sdk-build:admin', () ->
    gulp.watch(['build/admin/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:admin-booking', () ->
    gulp.watch(['build/admin-booking/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:admin-dashboard', () ->
    gulp.watch(['build/admin-dashboard/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:core', () ->
    gulp.watch(['build/core/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:events', () ->
    gulp.watch(['build/events/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:member', () ->
    gulp.watch(['build/member/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:public-booking', () ->
    gulp.watch(['build/public-booking/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:queue', () ->
    gulp.watch(['build/queue/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:services', () ->
    gulp.watch(['build/services/*'], ['build-project:process-top-files'])
    return

  gulp.task 'build-project:watch-sdk-build:settings', () ->
    gulp.watch(['build/settings/*'], ['build-project:process-top-files'])
    return

  return
