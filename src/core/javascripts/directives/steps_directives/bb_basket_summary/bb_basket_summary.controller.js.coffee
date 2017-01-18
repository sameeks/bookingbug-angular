'use strict'

angular.module('BB.Controllers').controller 'BasketSummary', ($scope) ->

  $scope.basket_items = $scope.bb.basket.items

  ###**
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbBasketSummary
  * @description
  * Marks the basket as reviewed and invokes the next step
  ###
  $scope.confirm = () =>
    $scope.bb.basket.reviewed = true
    $scope.decideNextPage()
