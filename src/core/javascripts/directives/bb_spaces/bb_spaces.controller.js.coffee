'use strict'

angular.module('BB.Controllers').controller 'SpaceList',
($scope, $rootScope, $q, ServiceService, LoadingService, BBModel) ->

  loader = LoadingService.$loader($scope)

  $rootScope.connection_started.then =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.init = (comp) =>
    BBModel.Space.$query(comp).then (items) =>
      if $scope.currentItem.category
        # if we've selected a category for the current item - limit the list of servcies to ones that are relevant
        items = items.filter (x) -> x.$has('category') && x.$href('category') == $scope.currentItem.category.self
      $scope.items = items
      if (items.length == 1 && !$scope.allowSinglePick)
        $scope.skipThisStep()
        $rootScope.services = items
        $scope.selectItem(items[0], $scope.nextRoute )
      else
        $scope.listLoaded = true
    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbSpaces
  * @description
  * Select the current item in according of item and route parameters
  *
  * @param {array} item The Space or BookableItem to select
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) =>
    $scope.currentItem.setService(item)
    $scope.decide_next_page(route)
