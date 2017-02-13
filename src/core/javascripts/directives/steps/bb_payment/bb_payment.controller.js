angular.module('BB.Controllers').controller('Payment', function($scope,  $rootScope,
  $q, $location, $window, $sce, $log, $timeout, LoadingService) {

  let loader = LoadingService.$loader($scope).notLoaded();

  if ($scope.purchase) { $scope.bb.total = $scope.purchase; }

  $rootScope.connection_started.then(function() {
    if ($scope.total) { $scope.bb.total = $scope.total; }
    if ($scope.bb && $scope.bb.total && $scope.bb.total.$href('new_payment')) { return $scope.url = $sce.trustAsResourceUrl($scope.bb.total.$href('new_payment')); }
  });

  /***
  * @ngdoc method
  * @name callNotLoaded
  * @methodOf BB.Directives:bbPayment
  * @description
  * Set not loaded state
  */
  $scope.callNotLoaded = () => {
    return loader.notLoaded();
  };


  /***
  * @ngdoc method
  * @name callSetLoaded
  * @methodOf BB.Directives:bbPayment
  * @description
  * Set loaded state
  */
  $scope.callSetLoaded = () => {
    return loader.setLoaded();
  };


  /***
  * @ngdoc method
  * @name paymentDone
  * @methodOf BB.Directives:bbPayment
  * @description
  * Handles payment success
  */
  $scope.paymentDone = function() {
    $scope.bb.payment_status = "complete";
    $scope.$emit('payment:complete');
    if ($scope.route_to_next_page) { return $scope.decideNextPage(); }
  };


  return $scope.error = message => $log.warn(`Payment Failure: ${message}`);
});
