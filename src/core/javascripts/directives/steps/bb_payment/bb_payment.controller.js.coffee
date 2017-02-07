'use strict'

angular.module('BB.Controllers').controller 'Payment', ($scope,  $rootScope,
  $q, $location, $window, $sce, $log, $timeout, LoadingService) ->

  loader = LoadingService.$loader($scope).notLoaded()

  $scope.bb.total = $scope.purchase if $scope.purchase

  $rootScope.connection_started.then ->
    $scope.bb.total = $scope.total if $scope.total
    $scope.url = $sce.trustAsResourceUrl($scope.bb.total.$href('new_payment')) if $scope.bb and $scope.bb.total and $scope.bb.total.$href('new_payment')

  ###**
  * @ngdoc method
  * @name callNotLoaded
  * @methodOf BB.Directives:bbPayment
  * @description
  * Set not loaded state
  ###
  $scope.callNotLoaded = () =>
    loader.notLoaded()


  ###**
  * @ngdoc method
  * @name callSetLoaded
  * @methodOf BB.Directives:bbPayment
  * @description
  * Set loaded state
  ###
  $scope.callSetLoaded = () =>
    loader.setLoaded()


  ###**
  * @ngdoc method
  * @name paymentDone
  * @methodOf BB.Directives:bbPayment
  * @description
  * Handles payment success
  ###
  $scope.paymentDone = () ->
    $scope.bb.payment_status = "complete"
    $scope.$emit('payment:complete')
    $scope.decideNextPage() if $scope.route_to_next_page


  $scope.error = (message) ->
    $log.warn("Payment Failure: " + message)
