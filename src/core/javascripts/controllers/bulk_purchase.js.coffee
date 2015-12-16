'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbBulkPurchases
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of bulk purchases for the currently in scroe company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbBulkPurchases   A hash of options
* @property {array} bulk_purchases An array of all services
* @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a resource or person
* @property {bulk_purchase} bulk_purchase The currectly selected bulk_purchase
* @example
*  <example module="BB"> 
*    <file name="index.html">
*   <div bb-api-url='https://uk.bookingbug.com'>
*   <div  bb-widget='{company_id:21}'>
*     <div bb-bulk-purchases>
*        <ul>
*          <li ng-repeat='bulk in bulk_purchases'> {{bulk.name}}</li>
*        </ul>
*     </div>
*     </div>
*     </div>
*   </file> 
*  </example>
* 
####

angular.module('BB.Directives').directive 'bbBulkPurchases', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'BulkPurchase'


angular.module('BB.Controllers').controller 'BulkPurchase', ($scope, $rootScope, BulkPurchaseService) ->

  $scope.controller = "public.controllers.BulkPurchase"

  $rootScope.connection_started.then ->
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->
    $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (company) ->
    BulkPurchaseService.query(company).then (bulk_purchase) ->
      $scope.bulk_purchases = bulk_purchase

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbBulkPurchases
  * @description
  * Select a bulk purchase into the current booking journey and route on to the next page dpending on the current page control
  *
  * @param {object} package Bulk_purchase or BookableItem to select
  * @param {string=} route A specific route to load
  ###

  $scope.selectItem = (item, route) ->
    if $scope.$parent.$has_page_control
      $scope.bulk_purchase = item
      false
    else
      $scope.booking_item.setBulkPurchase(item)
      $scope.decideNextPage(route)
      true

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbBulkPurchases
  * @description
  * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
  ###

  $scope.setReady = () =>
    if $scope.bulk_purchase
      $scope.booking_item.setBulkPurchase($scope.bulk_purchase)
      return true
    else
      return false

