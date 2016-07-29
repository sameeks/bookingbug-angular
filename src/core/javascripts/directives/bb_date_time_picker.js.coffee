###**
* @ngdoc directive
* @name BB.Directives.directive:bbDateTimePicker
* @scope
* @restrict A
*
* @description
* DateTime picker that combines date & timepicker and consolidates
* the Use of Moment.js in the App and Date in the pickers
*
* @param {object}  date   A moment.js date object
* @param {boolean}  showMeridian   Switch to show/hide meridian (optional, default:false)
* @param {number}  minuteStep Step for the timepicker (optional, default:10)
* @param {object}  minDate Min date value for datetimepicker
* @param {object}  maxDate Max date value for datetimepicker
###
angular.module('BB.Directives').directive 'bbDateTimePicker', (PathSvc) ->
  scope:
    date: '='
    showMeridian: '=?'
    minuteStep: '=?'
    minDate: '=?'
    maxDate: '=?'
    format: '=?'
    bbDisabled: '=?'
  restrict: 'A'
  templateUrl : 'bb_date_time_picker.html'
  controller: ($scope, $filter, $timeout, GeneralOptions) ->
    if !$scope.format?
      $scope.format = 'dd/MM/yyyy'

    unless $scope.bbDisabled?
      $scope.bbDisabled = false

    # Default minuteStep value
    $scope.minuteStep = GeneralOptions.calendar_minute_step if not $scope.minuteStep or typeof $scope.minuteStep == 'undefined'

    # Default showMeridian value
    $scope.showMeridian = GeneralOptions.twelve_hour_format if not $scope.showMeridian or typeof $scope.showMeridian == 'undefined'

    # Watch for changes in the timepicker and reassemble the new datetime
    $scope.$watch 'datetimeWithNoTz', (newValue, oldValue) ->

      if newValue? and moment(newValue).isValid() and newValue.getTime() != oldValue.getTime()
        assembledDate = moment()
        assembledDate.set({
          'year': parseInt(newValue.getFullYear())
          'month': parseInt(newValue.getMonth())
          'date': parseInt(newValue.getDate())
          'hour': parseInt(newValue.getHours())
          'minute': parseInt(newValue.getMinutes())
          'second': 0,
          'milliseconds': 0
        })

        $scope.date = assembledDate

    clearTimezone = (date)->
      if date? and moment(date).isValid()
        newDate = new Date();
        newDate.setFullYear(date.year())
        newDate.setMonth(date.month())
        newDate.setDate(date.date())
        newDate.setHours(date.hours())
        newDate.setMinutes(date.minutes())
        newDate.setSeconds(0)
        newDate.setMilliseconds(0)

        return newDate
      # otherwise undefined (important for timepicker)
      return undefined

    $scope.datetimeWithNoTz = clearTimezone($scope.date)

    $scope.$watch 'date', (newValue, oldValue) ->
      if newValue != oldValue && clearTimezone(newValue) != oldValue
        $scope.datetimeWithNoTz = clearTimezone(newValue)

    $scope.$watch 'minDate', (newValue, oldValue) ->
      if newValue != oldValue
        $scope.minDateClean = clearTimezone(newValue)

    $scope.$watch 'maxDate', (newValue, oldValue) ->
      if newValue != oldValue
        $scope.maxDateClean = clearTimezone(newValue)

    $scope.minDateClean = clearTimezone($scope.minDate)
    $scope.maxDateClean = clearTimezone($scope.maxDate)
