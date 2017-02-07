'use strict'

angular.module('BB.Controllers').controller 'TimeSlots', ($scope, $rootScope, $q, $attrs, FormDataStoreService, ValidatorService, LoadingService, halClient, BBModel) ->

  loader = LoadingService.$loader($scope).notLoaded()
  $rootScope.connection_started.then ->
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->
    loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  $scope.init = (company) ->
    $scope.booking_item ||= $scope.bb.current_item
    $scope.start_date = moment()
    $scope.end_date = moment().add(1, 'month')

    params =
      item: $scope.booking_item
      start_date: $scope.start_date.toISODate()
      end_date: $scope.end_date.toISODate()
    BBModel.Slot.$query($scope.bb.company, params).then (slots) ->
      $scope.slots = slots
      loader.setLoaded()
    , (err) ->
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  setItem = (slot) ->
    $scope.booking_item.setSlot(slot)

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbTimeSlots
  * @description
  * Select an item into the current booking journey and route on to the next page dpending on the current page control
  *
  * @param {object} slot The slot from list
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (slot, route) ->
    if $scope.$parent.$has_page_control
      setItem(slot)
      false
    else
      setItem(slot)
      $scope.decideNextPage(route)
      true
