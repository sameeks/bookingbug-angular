'use strict'

angular.module('BB.Controllers').controller 'CategoryList', (
  $scope, $rootScope, $q, LoadingService, BBModel) ->

  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.init = (comp) =>
    BBModel.Category.$query(comp).then (items) =>
      $scope.items = items
      if (items.length == 1)
        $scope.skipThisStep()
        $rootScope.categories = items
        $scope.selectItem(items[0], $scope.nextRoute )
      loader.setLoaded()
    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbCategories
  * @description
  * Select an item
  *
  * @param {object} item The Service or BookableItem to select
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) =>
    $scope.bb.current_item.setCategory(item)
    $scope.decideNextPage(route)
