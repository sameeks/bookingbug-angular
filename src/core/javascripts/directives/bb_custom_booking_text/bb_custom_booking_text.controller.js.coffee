'use strict'

angular.module('BB.Controllers').controller 'CustomBookingText', (
  $scope, $rootScope, $q, CustomTextService, LoadingService) ->

  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    CustomTextService.BookingText($scope.bb.company, $scope.bb.current_item).then (msgs) =>
      $scope.messages = msgs
      loader.setLoaded()
    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')




