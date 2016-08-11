module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpAngularTemplateCache = require('gulp-angular-templatecache')
  gulpFlatten = require('gulp-flatten')
  gulpTemplate = require('gulp-template')
  projectConfig = require('../helpers/project_config.js')

  gulp.task 'build-project-templates', () ->
    templatesSrcGlob = path.join args.getTestProjectRootPath(), 'src/templates/*.html'
    templatesDest = path.join args.getTestProjectRootPath(), 'dist'

    return gulp.src(templatesSrcGlob)
    .pipe(gulpAngularTemplateCache('templates.js', {module: 'BB'}))
    .pipe(gulpFlatten())
    .pipe(gulpTemplate(projectConfig.getConfig()))
    .pipe(gulp.dest(templatesDest));

  gulp.task 'build-project-templates:sdk-admin:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-admin-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-booking:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-admin-dashboard:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:admin-dashboard:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-core:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:core:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-events:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:events:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-member:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:member:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-public-booking:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:public-booking:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-services:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:services:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:sdk-settings:rebuild', (cb) ->
    plugins.sequence(
      'build-sdk:settings:templates'
      'build-project-templates'
      cb
    )
    return

  gulp.task 'build-project-templates:watch', (cb) ->

    templatesSrcGlob = path.join args.getTestProjectRootPath(), 'src/templates/*.html'
    gulp.watch(templatesSrcGlob, ['build-project-templates'])

    gulp.watch(['src/admin/templates/**/*'], ['build-project-templates:sdk-admin:rebuild'])
    gulp.watch(['src/admin-booking/templates/**/*'], ['build-project-templates:sdk-admin-booking:rebuild'])
    gulp.watch(['src/admin-dashboard/templates/**/*'], ['build-project-templates:sdk-admin-dashboard:rebuild'])
    gulp.watch(['src/core/templates/**/*'], ['build-project-templates:sdk-core:rebuild'])
    gulp.watch(['src/events/templates/**/*'], ['build-project-templates:sdk-events:rebuild'])
    gulp.watch(['src/member/templates/**/*'], ['build-project-templates:sdk-member:rebuild'])
    gulp.watch(['src/public-booking/templates/**/*'], ['build-project-templates:sdk-public-booking:rebuild'])
    gulp.watch(['src/services/templates/**/*'], ['build-project-templates:sdk-services:rebuild'])
    gulp.watch(['src/settings/templates/**/*'], ['build-project-templates:sdk-settings:rebuild'])

    cb()
    return

  return
