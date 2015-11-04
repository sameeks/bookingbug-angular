'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbDurations
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of durations for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} duration The duration list
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbDurations', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DurationList'


angular.module('BB.Controllers').controller 'DurationList', ($scope,  $rootScope, PageControllerService, $q, $attrs, AlertService) ->
  $scope.controller = "public.controllers.DurationList"
  $scope.notLoaded $scope

  angular.extend(this, new PageControllerService($scope, $q))

  $rootScope.connection_started.then ->
    $scope.loadData()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.loadData = () =>
    id = $scope.bb.company_id
    service = $scope.bb.current_item.service
    if service && !$scope.durations
      $scope.durations =
        (for d in _.zip(service.durations, service.prices)
          {value: d[0], price: d[1]})
      
      initial_duration = $scope.$eval($attrs.bbInitialDuration)

      for duration in $scope.durations
        # does the current item already have a duration?
        if $scope.bb.current_item.duration && duration.value == $scope.bb.current_item.duration
          $scope.duration = duration
        else if initial_duration and initial_duration is duration.value
          $scope.duration = duration
          $scope.bb.current_item.setDuration(duration.value)

        if duration.value < 60
          duration.pretty = duration.value + " minutes"
        else if duration.value == 60
          duration.pretty = "1 hour"
        else
          duration.pretty = Math.floor(duration.value/60) + " hours"
          rem = duration.value % 60
          if rem != 0
            duration.pretty += " " + rem + " minutes"

      if $scope.durations.length == 1
        $scope.skipThisStep()
        $scope.selectDuration($scope.durations[0], $scope.nextRoute)

    $scope.setLoaded $scope

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbDurations
  * @description
  * Select duration of the list in according of dur and route parameter
  *
  * @param {object} dur The duration list
  * @param {string=} route A specific route to load
  ###
  $scope.selectDuration = (dur, route) =>
    if $scope.$parent.$has_page_control
      $scope.duration = dur
      return
    else
      $scope.bb.current_item.setDuration(dur.value)
      $scope.decideNextPage(route)
      return true

  ###**
  * @ngdoc method
  * @name durationChanged
  * @methodOf BB.Directives:bbDurations
  * @description
  * Change the list duration and update item
  ###
  $scope.durationChanged = () =>
    $scope.bb.current_item.setDuration($scope.duration.value)
    $scope.broadcastItemUpdate()

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbDurations
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () =>
    if $scope.duration
      $scope.bb.current_item.setDuration($scope.duration.value)
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select a duration" })
      return false


  # when the current item is updated, reload the duration data
  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadData()
