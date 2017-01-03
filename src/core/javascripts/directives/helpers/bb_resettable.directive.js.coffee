'use strict'

# bbResettable
# Registers inputs with the bbFormResettable controller allowing them to be cleared
angular.module('BB.Directives').directive 'bbResettable', () ->
  restrict: 'A',
  require: ['ngModel', '^bbFormResettable'],
  link: (scope, element, attrs, ctrls) ->
    ngModelCtrl        = ctrls[0]
    formResettableCtrl = ctrls[1]
    formResettableCtrl.registerInput(attrs.ngModel, ngModelCtrl)
