'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbDurations
* @restrict AE
* @scope true
*
* @description
* Loads a list of durations for the currently in scope company.
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} duration Duration list
* @property {object} alert Alert service - see {@link BB.Services:Alert Alert Service}
* @example
*  <example module="BB">
*    <file name="index.html">
*      <div bb-api-url='https://dev01.bookingbug.com'>
*        <div bb-widget='{company_id:37167}'>
*          <div bb-durations>
*
*          </div>
*        </div>
*      </div>
*    </file>
*  </example>
####

angular.module('BB.Directives').directive 'bbDurations', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DurationList'
  link: (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbDurations) or {}
    scope.directives = "public.DurationList"


angular.module('BB.Controllers').controller 'DurationList',
($scope, $attrs, $rootScope, $q, $filter, PageControllerService, AlertService, LoadingService) ->

  $scope.controller = "public.controllers.DurationList"
  loader = LoadingService.$loader($scope).notLoaded()

  angular.extend(this, new PageControllerService($scope, $q))

  options = $scope.$eval($attrs.bbDurations) or {}

  $rootScope.connection_started.then ->
    $scope.loadData()
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


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

        duration.pretty = $filter('time_period')(duration.value)
        duration.pretty += " (#{$filter('currency')(duration.price)})" if options.show_prices

      if $scope.durations.length == 1
        $scope.skipThisStep()
        $scope.selectDuration($scope.durations[0], $scope.nextRoute)

    loader.setLoaded()

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbDurations
  * @description
  * Selects list duration according to duration and route parameter.
  *
  * @param {object} dur Duration list
  * @param {string=} route Specific route to load
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
  * Change the list duration and update item.
  ###
  $scope.durationChanged = () =>
    $scope.bb.current_item.setDuration($scope.duration.value)
    $scope.broadcastItemUpdate()

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbDurations
  * @description
  * Sets page section as ready.
  ###
  $scope.setReady = () =>
    if $scope.duration
      $scope.bb.current_item.setDuration($scope.duration.value)
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select a duration" })
      return false


  # when the current item is updated, reload data duration
  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadData()
