
gulp.task 'build-sdk:admin:watch', () ->
  gulp.watch(['src/admin/images/**/*'], ['build-sdk:admin:images'])
  gulp.watch(['src/admin/templates/**/*'], ['build-sdk:admin:templates'])


gulp.task 'build-sdk:admin-booking:watch', () ->
  gulp.watch(['src/admin-booking/stylesheets/**/*'], ['build-sdk:admin-booking:stylesheets'])
  gulp.watch(['src/admin-booking/templates/**/*'], ['build-sdk:admin-booking:templates'])

gulp.task 'build-sdk:admin-dashboard:watch', () ->
  gulp.watch(['src/admin-dashboard/stylesheets/**/*'], ['build-sdk:admin-dashboard:stylesheets'])
  gulp.watch(['src/admin-dashboard/images/**/*'], ['build-sdk:admin-dashboard:images'])
  gulp.watch(['src/admin-dashboard/templates/**/*'], ['build-sdk:admin-dashboard:templates'])

gulp.task 'build-sdk:core:watch', () ->
  gulp.watch(['src/core/stylesheets/**/*'], ['build-sdk:core:stylesheets'])
  gulp.watch(['src/core/templates/**/*'], ['build-sdk:core:templates'])

gulp.task 'build-sdk:events:watch', () ->
  gulp.watch(['src/events/templates/**/*'], ['build-sdk:events:templates'])

gulp.task 'build-sdk:member:watch', () ->
  gulp.watch(['src/member/stylesheets/**/*'], ['build-sdk:member:stylesheets'])
  gulp.watch(['src/member/templates/**/*'], ['build-sdk:member:templates'])

gulp.task 'build-sdk:public-booking:watch', () ->
  gulp.watch(['src/public-booking/stylesheets/**/*'], ['build-sdk:public-booking:stylesheets'])
  gulp.watch(['src/public-booking/fonts/**/*'], ['build-sdk:public-booking:fonts'])
  gulp.watch(['src/public-booking/images/**/*'], ['build-sdk:public-booking:images'])
  gulp.watch(['src/public-booking/templates/**/*'], ['build-sdk:public-booking:templates'])

gulp.task 'build-sdk:queue:watch', () ->
  gulp.watch(['src/queue/templates/**/*'], ['build-sdk:queue:templates'])

gulp.task 'build-sdk:services:watch', () ->
  gulp.watch(['src/services/templates/**/*'], ['build-sdk:services:templates'])

gulp.task 'build-sdk:settings:watch', () ->
  gulp.watch(['src/settings/templates/**/*'], ['build-sdk:settings:templates'])
