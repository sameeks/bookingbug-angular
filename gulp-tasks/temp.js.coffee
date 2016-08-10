
gulp.task 'build-sdk:admin:watch', () ->
  gulp.watch(['src/admin/images/**/*'], ['build-sdk:admin:images'])


gulp.task 'build-sdk:admin-booking:watch', () ->
  gulp.watch(['src/admin-booking/stylesheets/**/*'], ['build-sdk:admin-booking:stylesheets'])

gulp.task 'build-sdk:admin-dashboard:watch', () ->
  gulp.watch(['src/admin-dashboard/stylesheets/**/*'], ['build-sdk:admin-dashboard:stylesheets'])
  gulp.watch(['src/admin-dashboard/images/**/*'], ['build-sdk:admin-dashboard:images'])

gulp.task 'build-sdk:core:watch', () ->
  gulp.watch(['src/core/stylesheets/**/*'], ['build-sdk:core:stylesheets'])


gulp.task 'build-sdk:member:watch', () ->
  gulp.watch(['src/member/stylesheets/**/*'], ['build-sdk:member:stylesheets'])

gulp.task 'build-sdk:public-booking:watch', () ->
  gulp.watch(['src/public-booking/stylesheets/**/*'], ['build-sdk:public-booking:stylesheets'])
  gulp.watch(['src/public-booking/fonts/**/*'], ['build-sdk:public-booking:fonts'])
  gulp.watch(['src/public-booking/images/**/*'], ['build-sdk:public-booking:images'])

