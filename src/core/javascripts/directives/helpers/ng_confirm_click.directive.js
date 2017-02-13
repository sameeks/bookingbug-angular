'use strict'

angular.module('BB.Directives').directive 'ngConfirmClick', () ->
  link: (scope, element, attr) ->
    msg = attr.ngConfirmClick || "Are you sure?"
    clickAction = attr.ngConfirmedClick
    element.bind 'click', (event) =>
      if window.confirm(msg)
        scope.$eval(clickAction)
