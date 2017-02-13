// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('CustomBookingText', function(
  $scope, $rootScope, $q, CustomTextService, LoadingService) {

  let loader = LoadingService.$loader($scope).notLoaded();

  return $rootScope.connection_started.then(() => {
    return CustomTextService.BookingText($scope.bb.company, $scope.bb.current_item).then(msgs => {
      $scope.messages = msgs;
      return loader.setLoaded();
    }
    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
  }
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
});




