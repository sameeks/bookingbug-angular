module.exports = (gulp, plugins, path) ->

  gulp.task 'deploy', (cb) ->

    plugins.sequence(
     'build-widget'
     'deploy-aws'
     cb
    )

    return
