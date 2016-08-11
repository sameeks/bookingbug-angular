module.exports = (gulp, plugins, path) ->

  gulp.task 'deploy', (cb) ->

    plugins.sequence(
     'build-sdk',
     'build-project'
     'deploy-aws'
     cb
    )

    return
