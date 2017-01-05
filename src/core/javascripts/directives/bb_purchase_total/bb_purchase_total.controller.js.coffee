'use strict'

angular.module('BB.Controllers').controller 'PurchaseTotal', ($scope,
  $rootScope, $window, BBModel, $q) ->

  $scope.controller = "public.controllers.PurchaseTotal"

  angular.extend(this, new $window.PageController($scope, $q))

  ###**
  * @ngdoc method
  * @name load
  * @methodOf BB.Directives:bbPurchaseTotal
  * @description
  * Load the total purchase by id
  *
  * @param {integer} total_id The total id of the total purchase
  ###
  $scope.load = (total_id) =>
    $rootScope.connection_started.then =>
      $scope.loadingTotal = BBModel.PurchaseTotal.$query({company: $scope.bb.company, total_id: total_id})
      $scope.loadingTotal.then (total) =>
        $scope.total = total
