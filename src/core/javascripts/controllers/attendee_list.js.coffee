angular.module('BB.Directives').directive 'bbAttendees', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller: ($scope, $rootScope, $q, PurchaseService, BBModel, AlertService, ValidatorService) ->

    $scope.validator = ValidatorService

    $rootScope.connection_started.then () ->
      initialise()


    initialise = () ->
      $scope.items = $scope.bb.basket.timeItems()


    updateBooking = () ->

      deferred = $q.defer()

      params =
        purchase: $scope.bb.moving_purchase
        bookings: $scope.bb.basket.items
      PurchaseService.update(params).then (purchase) ->
        $scope.bb.purchase = purchase
        $scope.setLoaded $scope
        $scope.bb.current_item.move_done = true
        $rootScope.$broadcast "booking:updated"
        deferred.resolve()
      , (err) ->
        deferred.reject()

      return deferred.promise



    ###**
    * @ngdoc method
    * @name updateBooking
    * @methodOf BB.Directives:bbAttendees
    * @description
    * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
    ###
    $scope.changeAttendees = () ->

      return false if !$scope.bb.current_item.ready or !$scope.bb.moving_purchase
      
      $scope.notLoaded $scope

      if $scope.$parent.$has_page_control
        return updateBooking()
      else
        updateBooking().then () ->
          $scope.decideNextPage('purchase')
          AlertService.raise('ATTENDEES_CHANGED')
        , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
        


    ###**
    * @ngdoc method
    * @name setReady
    * @methodOf BB.Directives:bbAttendees
    * @description
    * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
    ###
    $scope.setReady = () ->
      return $scope.changeAttendees()