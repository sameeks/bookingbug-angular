module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpAngularTemplateCache = require('gulp-angular-templatecache')
  gulpFlatten = require('gulp-flatten')
  gulpTemplate = require('gulp-template')
  projectConfig = require('../helpers/project_config.js')

  gulp.task 'build-project:templates', () ->
    templatesSrcGlob = path.join args.getTestProjectRootPath(), 'src/templates/*.html'
    templatesDest = path.join args.getTestProjectRootPath(), 'dist'

    return gulp.src(templatesSrcGlob)
    .pipe(gulpAngularTemplateCache('templates.js', {module: 'BB'}))
    .pipe(gulpFlatten())
    .pipe(gulpTemplate(projectConfig.getConfig()))
    .pipe(gulp.dest(templatesDest));


  return
