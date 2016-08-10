module.exports = (gulp, plugins, path)->
  args = require('../helpers/args.js')
  gulpTemplate = require('gulp-template')
  projectConfig = require('../helpers/project_config.js')

  gulp.task 'build-project:www', () ->
    src = path.join args.getTestProjectRootPath(), 'src/www/*.*'
    dist = path.join args.getTestProjectRootPath(), 'dist'
    return gulp.src(src)
    .pipe(gulpTemplate(projectConfig.getConfig()))
    .pipe(gulp.dest(dist))

  return
