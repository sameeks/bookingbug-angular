'use strict'

angular.module('BB.Controllers').controller 'BulkPurchase',
($scope, $rootScope, BBModel) ->

  $scope.controller = "public.controllers.BulkPurchase"

  $rootScope.connection_started.then ->
    $scope.init($scope.bb.company) if $scope.bb.company

  $scope.init = (company) ->
    $scope.booking_item ||= $scope.bb.current_item
    BBModel.BulkPurchase.$query(company).then (bulk_purchases) ->
      $scope.bulk_purchases = bulk_purchases


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
