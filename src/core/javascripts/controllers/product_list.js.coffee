'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbProductList
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of product for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} products The products from the list
* @property {array} item The item of the product list
* @property {array} booking_item The booking item
* @property {product} product The currectly selected product
####


angular.module('BB.Directives').directive 'bbProductList', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ProductList'
  link : (scope, element, attrs) ->
    if attrs.bbItem
      scope.booking_item = scope.$eval( attrs.bbItem )
    if attrs.bbShowAll
      scope.show_all = true
    return

angular.module('BB.Controllers').controller 'ProductList', ($scope,
    $rootScope, $q, $attrs, ItemService, FormDataStoreService, ValidatorService,
    PageControllerService, halClient) ->

  $scope.controller = "public.controllers.ProductList"

  $scope.notLoaded $scope

  $scope.validator = ValidatorService

  $rootScope.connection_started.then ->
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->
    $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (company) ->
    $scope.booking_item ||= $scope.bb.current_item

    company.$get('products').then (products) ->
      products.$get('products').then (products) ->
        $scope.products = products
        $scope.setLoaded $scope

   ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbProductList
  * @description
  * Select an item from the product list in according of item and route parameter
  *
  * @param {array} item The array items
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) ->
    if $scope.$parent.$has_page_control
      $scope.product = item
      false
    else
      $scope.booking_item.setProduct(item)
      $scope.decideNextPage(route)
      true

