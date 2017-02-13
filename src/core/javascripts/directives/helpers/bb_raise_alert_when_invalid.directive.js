'use strict'

# Form directive to allow users to specify if they want the form to raise alerts when
# there is invalid input.
angular.module('BB.Directives').directive 'bbRaiseAlertWhenInvalid', ($compile) ->
  require: '^form'
  link: (scope, element, attr, ctrl) ->
    ctrl.raise_alerts = true

    options = scope.$eval attr.bbRaiseAlertWhenInvalid
    ctrl.alert = options.alert if options and options.alert
