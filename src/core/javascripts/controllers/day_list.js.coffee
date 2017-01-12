'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbDayList
* @restrict AE
* @scope true
*
* @description
*
* Next 5 week calendar with time selection
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*ice}
####


angular.module('BB.Directives').directive 'bbDayList', () ->
  restrict: 'A'
  replace: true
  scope : true
  controller : 'DayList'

angular.module('BB.Controllers').controller 'DayList', ($scope,  $rootScope, $q, DayService) ->

  $scope.controller = "public.controllers.DayList"

  # Load up some day based data
  $rootScope.connection_started.then ->
    if !$scope.current_date && $scope.last_selected_date
      $scope.selected_date = $scope.last_selected_date.clone()
      setCurrentDate($scope.last_selected_date.clone().startOf('week'))
    else if !$scope.current_date
      setCurrentDate(moment().startOf('week'))
    $scope.loadData()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.selectDay = (day) =>
    return if !day.spaces || (day.spaces and day.spaces == 0)
    $scope.setLastSelectedDate(day.date)
    $scope.selected_date = day.date
    $scope.bb.current_item.setDate(day)
    $scope.$broadcast('dateChanged', day.date)


  setCurrentDate = (date) ->
    $scope.current_date = date
    $scope.current_date_js = $scope.current_date.toDate()


  $scope.add = (type, amount) =>
    setCurrentDate($scope.current_date.add(amount, type))
    $scope.loadData()


  $scope.subtract = (type, amount) =>
    $scope.add(type, -amount)


  $scope.currentDateChanged = () ->
    date = moment($scope.current_date_js).startOf('week')
    setCurrentDate(date)
    $scope.loadData()


   # disable any day but monday
  $scope.isDateDisabled = (date, mode) ->
    date = moment(date)
    result = mode is 'day' and (date.day() != 1 or date.isBefore(moment(),'day'))
    return result


  # calculate if the current earlist date is in the past - in which case we might want to disable going backwards
  $scope.isPast = () =>
    return true if !$scope.current_date
    return moment().isAfter($scope.current_date)


  $scope.loadData = () ->
    $scope.day_data = {}
    $scope.notLoaded $scope
    $scope.end_date = moment($scope.current_date).add(5, 'weeks')

    promise = DayService.query({company: $scope.bb.company, cItem: $scope.bb.current_item, date: $scope.current_date.toISODate(), edate: $scope.end_date.toISODate(), client: $scope.client })

    promise.then (days) ->
      for day in days
        $scope.day_data[day.string_date] = {spaces:day.spaces, date: day.date}

      # group the day data by week
      $scope.weeks = _.groupBy $scope.day_data, (day) -> day.date.week()
      $scope.weeks = _.toArray $scope.weeks

      $scope.setLoaded $scope

    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
