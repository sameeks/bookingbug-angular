
gulp.task 'build-sdk:admin:watch', () ->
  gulp.watch(['src/admin/images/**/*'], ['build-sdk:admin:images'])

gulp.task 'build-sdk:admin-dashboard:watch', () ->
  gulp.watch(['src/admin-dashboard/images/**/*'], ['build-sdk:admin-dashboard:images'])

gulp.task 'build-sdk:public-booking:watch', () ->
  gulp.watch(['src/public-booking/images/**/*'], ['build-sdk:public-booking:images'])
  gulp.watch(['src/public-booking/fonts/**/*'], ['build-sdk:public-booking:fonts'])

