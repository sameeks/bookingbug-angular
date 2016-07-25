module.exports = (gulp, plugins)->

  gulp.task 'test:unit', (cb)->
    plugins.sequence(
      [
        'test:unit:test-examples'
        'test:unit:core'
        'test:unit:admin'
        'test:unit:admin-booking'
        'test:unit:admin-dashboard'
        'test:unit:events'
        'test:unit:member'
        'test:unit:services'
        'test:unit:settings'
      ]
      cb
    )

  gulp.task 'test:unit-ci', (cb)->
    plugins.sequence(
      'test:unit-ci:test-examples'
      'test:unit-ci:core'
      'test:unit-ci:admin'
      'test:unit-ci:admin-booking'
      'test:unit-ci:admin-dashboard'
      'test:unit-ci:events'
      'test:unit-ci:member'
      'test:unit-ci:services'
      'test:unit-ci:settings'
      cb
    )
