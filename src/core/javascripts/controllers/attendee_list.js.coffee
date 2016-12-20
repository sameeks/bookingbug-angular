'use strict'

angular.module('BB.Directives').directive 'bbAttendees', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller: ($scope, $rootScope, $q, PurchaseService, AlertService,
    ValidatorService, LoadingService, BBModel) ->

    $scope.validator = ValidatorService
    loader = LoadingService.$loader($scope)

    $rootScope.connection_started.then () ->
      initialise()


    initialise = () ->
      $scope.items = $scope.bb.basket.timeItems()


    updateBooking = () ->

      deferred = $q.defer()

      params =
        purchase: $scope.bb.moving_purchase
        bookings: $scope.bb.basket.items
        notify: true
      PurchaseService.update(params).then (purchase) ->
        $scope.bb.purchase = purchase
        loader.setLoaded()
        $rootScope.$broadcast "booking:updated"
        deferred.resolve()
      , (err) ->
        deferred.reject()

      return deferred.promise


    ###**
    * @ngdoc method
    * @name markItemAsChanged
    * @methodOf BB.Directives:bbAttendees
    * @description
    * Call this when an attendee is changed
    ###
    $scope.markItemAsChanged = (item) ->
      item.attendee_changed = true



    ###**
    * @ngdoc method
    * @name updateBooking
    * @methodOf BB.Directives:bbAttendees
    * @description
    * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
    ###
    $scope.changeAttendees = () ->

      return false if !$scope.bb.current_item.ready or !$scope.bb.moving_purchase

      deferred = $q.defer()

      loader.notLoaded()

      client_promises = []

      for item in $scope.items

        if item.attendee_changed

          client = new BBModel.Client()
          client.first_name = item.first_name
          client.last_name  = item.last_name

          client_promises.push(BBModel.Client.$create_or_update($scope.bb.company, client))

        else

          client_promises.push($q.when([]))


      $q.all(client_promises).then (result) ->

        for item, index in $scope.items
          if result[index] and result[index].id
            item.client_id = result[index].id

        updateBooking().then () ->
          if $scope.$parent.$has_page_control
            deferred.resolve()
          else
            $scope.decideNextPage('purchase')
            AlertService.raise('ATTENDEES_CHANGED')
            deferred.resolve()
        , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

      return deferred.promise



    ###**
    * @ngdoc method
    * @name setReady
    * @methodOf BB.Directives:bbAttendees
    * @description
    * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
    ###
    $scope.setReady = () ->
      return $scope.changeAttendees()

