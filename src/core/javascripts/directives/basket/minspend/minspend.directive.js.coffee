'use strict'

angular.module('BB.Directives').directive 'bbMinSpend', () ->
  restrict: 'A'
  scope: true
  controller: ($scope, $element, $attrs, AlertService, $filter) ->

    options = $scope.$eval $attrs.bbMinSpend or {}
    $scope.min_spend = options.min_spend or 0
    #$scope.items = options.items or {}

    $scope.setReady = () ->
      return checkMinSpend()

    checkMinSpend = () ->
      price = 0
      for item in $scope.bb.stacked_items
        price += (item.service.price)

      if price >= $scope.min_spend
        AlertService.clear()
        return true
      else
        AlertService.clear()
        price = $filter('ipretty_price')($scope.min_spend)
        AlertService.add("warning", { msg: "You need to spend at least #{price} to make a booking."})
        return false
