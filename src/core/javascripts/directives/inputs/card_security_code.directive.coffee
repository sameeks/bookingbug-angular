'use strict'
angular.module('BB.Directives').directive "cardSecurityCode", ->

  linker = (scope, element, attributes) ->
    scope.$watch 'cardType', (newValue) ->
      if newValue == 'american_express'
        element.attr('maxlength', 4)
        element.attr('placeholder', "••••")
      else
        element.attr('maxlength', 3)
        element.attr('placeholder', "•••")

  return {
    restrict: "AC"
    link: linker
    scope: {
      'cardType': '='
    }
  }
