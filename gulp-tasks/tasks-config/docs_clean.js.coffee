module.exports = (gulp, plugins, path)->
  del = require('del')

  gulp.task 'docs:clean', (cb) ->
    del.sync(['docs']);
    cb()
    return
