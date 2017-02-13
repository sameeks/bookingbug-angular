'use strict'

angular.module('BB.Controllers').controller 'CustomConfirmationText', ($scope, $rootScope, CustomTextService, $q, LoadingService) ->
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