'use strict'


angular.module('BB.Directives').directive 'bbBasketList', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'BasketList'
