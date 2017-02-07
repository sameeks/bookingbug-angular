'use strict'

angular.module('BB.Controllers').controller 'ProductList', ($scope,
    $rootScope, $q, $attrs, ItemService, FormDataStoreService, ValidatorService, LoadingService) ->

  loader = LoadingService.$loader($scope).notLoaded()

  $scope.validator = ValidatorService

  $rootScope.connection_started.then ->
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->
    loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.init = (company) ->
    $scope.booking_item ||= $scope.bb.current_item

    company.$get('products').then (products) ->
      products.$get('products').then (products) ->
        $scope.products = products
        loader.setLoaded()

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
