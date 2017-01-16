'use strict'

angular.module('BB.Controllers').controller 'CustomBookingText', (
  $scope, $rootScope, $q, CustomTextService, LoadingService) ->

  $scope.controller = "public.controllers.CustomBookingText"
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    CustomTextService.BookingText($scope.bb.company, $scope.bb.current_item).then (msgs) =>
      $scope.messages = msgs
      loader.setLoaded()
    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')



angular.module('BB.Controllers').controller 'CustomConfirmationText', ($scope, $rootScope, CustomTextService, $q, PageControllerService, LoadingService) ->
  $scope.controller = "public.controllers.CustomConfirmationText"
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then ->
    $scope.loadData()
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name loadData
  * @methodOf BB.Directives:bbCustomBookingText
  * @description
  * Load data and display a text message
  ###
  $scope.loadData = () =>

    if $scope.total

      CustomTextService.confirmationText($scope.bb.company, $scope.total).then (msgs) ->
        $scope.messages = msgs
        loader.setLoaded()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

    else if $scope.loadingTotal

      $scope.loadingTotal.then (total) ->
        CustomTextService.confirmationText($scope.bb.company, total).then (msgs) ->
          $scope.messages = msgs
          loader.setLoaded()
        , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

    else
      loader.setLoaded()
