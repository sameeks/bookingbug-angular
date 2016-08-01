module.exports = (gulp, plugins)->
  gulp.task 'test:unit-dependencies', (cb)->
    plugins.sequence(
      [
        'test:unit-dependencies:core'
        'test:unit-dependencies:admin'
        'test:unit-dependencies:admin-booking'
        'test:unit-dependencies:admin-dashboard'
        'test:unit-dependencies:events'
        'test:unit-dependencies:member'
        'test:unit-dependencies:services'
        'test:unit-dependencies:settings'
        'test:unit-dependencies:test-examples'
      ]
      cb
    )

  gulp.task 'test:unit', (cb)->
    plugins.sequence(
      [
        'test:unit:core'
        'test:unit:admin'
        'test:unit:admin-booking'
        'test:unit:admin-dashboard'
        'test:unit:events'
        'test:unit:member'
        'test:unit:services'
        'test:unit:settings'
        'test:unit:test-examples'
      ]
      cb
    )

  gulp.task 'test:unit-ci', (cb)->
    plugins.sequence(
      'test:unit-ci:core'
      'test:unit-ci:admin'
      'test:unit-ci:admin-booking'
      'test:unit-ci:admin-dashboard'
      'test:unit-ci:events'
      'test:unit-ci:member'
      'test:unit-ci:services'
      'test:unit-ci:settings'
      'test:unit-ci:test-examples'
      cb
    )
