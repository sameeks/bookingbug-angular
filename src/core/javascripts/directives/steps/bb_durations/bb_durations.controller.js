// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('DurationList', function($scope, $attrs, $rootScope, $q, $filter, AlertService, ValidatorService, LoadingService, $translate) {

  let duration;
  let loader = LoadingService.$loader($scope).notLoaded();

  let options = $scope.$eval($attrs.bbDurations) || {};

  $rootScope.connection_started.then(() => $scope.loadData()
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


  $scope.loadData = () => {
    let id = $scope.bb.company_id;
    let { service } = $scope.bb.current_item;
    if (service) {
      $scope.durations =
        (Array.from(_.zip(service.durations, service.prices)).map((d) => (
          {value: d[0], price: d[1]})));

      let initial_duration = $scope.$eval($attrs.bbInitialDuration);

      for (duration of Array.from($scope.durations)) {
        // does the current item already have a duration?
        if ($scope.bb.current_item.duration && (duration.value === $scope.bb.current_item.duration)) {
          $scope.duration = duration;
        } else if (initial_duration && (initial_duration === duration.value)) {
          $scope.duration = duration;
          $scope.bb.current_item.setDuration(duration.value);
        }

        duration.pretty = $filter('time_period')(duration.value);
        if (options.show_prices) { duration.pretty += ` (${$filter('currency')(duration.price)})`; }
      }

      if ($scope.durations.length === 1) {
        $scope.skipThisStep();
        $scope.selectDuration($scope.durations[0], $scope.nextRoute);
      }
    }

    return loader.setLoaded();
  };

  /***
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbDurations
  * @description
  * Select duration of the list in according of dur and route parameter
  *
  * @param {object} dur The duration list
  * @param {string=} route A specific route to load
  */
  $scope.selectDuration = (dur, route) => {
    if ($scope.$parent.$has_page_control) {
      $scope.duration = dur;
      return;
    } else {
      $scope.bb.current_item.setDuration(dur.value);
      $scope.decideNextPage(route);
      return true;
    }
  };

  /***
  * @ngdoc method
  * @name durationChanged
  * @methodOf BB.Directives:bbDurations
  * @description
  * Change the list duration and update item
  */
  $scope.durationChanged = () => {
    $scope.bb.current_item.setDuration($scope.duration.value);
    return $scope.broadcastItemUpdate();
  };

  /***
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbDurations
  * @description
  * Set this page section as ready
  */
  $scope.setReady = () => {
    if ($scope.duration) {
      $scope.bb.current_item.setDuration($scope.duration.value);
      return true;
    } else {
      AlertService.clear();
      AlertService.add("danger", { msg: $translate.instant('PUBLIC_BOOKING.DURATION_LIST.DURATON_NOT_SELECTED_ALERT')});
      return false;
    }
  };


  // when the current item is updated, reload the duration data
  return $scope.$on("currentItemUpdate", event => $scope.loadData());
});
