'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbPurchaseTotal
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of purchase total for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} total The total purchase
####


angular.module('BB.Directives').directive 'bbPurchaseTotal', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PurchaseTotal'
  link: (scope, element, attrs) ->
    scope.directives = "public.PurchaseTotal"


angular.module('BB.Controllers').controller 'PurchaseTotal',
($scope, $rootScope, $window, PurchaseTotalService, $q) ->
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
      $scope.loadingTotal = PurchaseTotalService.query({company: $scope.bb.company, total_id: total_id})
      $scope.loadingTotal.then (total) =>
        $scope.total = total

