###**
* @ngdoc directive
* @name BBAdminBooking.directive:bbDateTimePicker
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
* @param {object}  date Min date value for datetimepicker
* @param {object}  date Max date value for datetimepicker
###
angular.module('BBAdminBooking').directive 'bbDateTimePicker', (PathSvc) ->
  scope: 
    date: '='
    showMeridian: '=?'
    minuteStep: '=?'
    minDate: '=?'
    maxDate: '=?'
  restrict: 'A'
  templateUrl : (element, attrs) ->
    PathSvc.directivePartial "_datetime_picker"
  controller: ($scope, $filter, $timeout, GeneralOptions) ->
    # Default minuteStep value
    $scope.minuteStep = GeneralOptions.calendar_minute_step if not $scope.minuteStep or typeof $scope.minuteStep == 'undefined'

    # Default showMeridian value
    $scope.showMeridian = GeneralOptions.twelve_hour_format if not $scope.showMeridian or typeof $scope.showMeridian == 'undefined'

    # Watch for changes in the timepicker and reassemble the new datetime
    $scope.$watch 'datetimeWithNoTz', (newValue, oldValue) ->
      newValue = new Date(newValue)
      if newValue? and moment(newValue).isValid()
        assembledDate = moment()
        assembledDate.set({
          'year': parseInt(newValue.getFullYear())
          'month': parseInt(newValue.getMonth()) 
          'date': parseInt(newValue.getDate())
          'hour': parseInt(newValue.getHours())
          'minute': parseInt(newValue.getMinutes())
          'second': 0,
        })

        # These checks are for the timepicker explicitly because our version of bootstrap-ui
        # 0.12.0 does not support min-max values for the timepicker 
        # @todo remove this and refactor accordingly once version is updated
        if $scope.minDateClean? 
          minDateDate = new Date($scope.minDateClean)
          if (newValue.getTime()/1000) < (minDateDate.getTime()/1000)
            if newValue.getHours() < minDateDate.getHours()
              assembledDate.hours(parseInt(minDateDate.getHours()))

            if newValue.getMinutes() < minDateDate.getMinutes()
              assembledDate.minutes(parseInt(minDateDate.getMinutes()))  

            $scope.datetimeWithNoTz = $filter('clearTimezone')(assembledDate.format())

        if $scope.maxDateClean? 
          maxDateClean = new Date($scope.maxDateClean)
          if (newValue.getTime()/1000) > (maxDateClean.getTime()/1000)
            if newValue.getHours() > maxDateClean.getHours()
              assembledDate.hours(parseInt(maxDateClean.getHours()))

            if newValue.getMinutes() > maxDateClean.getMinutes()
              assembledDate.minutes(parseInt(maxDateClean.getMinutes()))  

            $scope.datetimeWithNoTz = $filter('clearTimezone')(assembledDate.format())    

        $scope.date = assembledDate.format()
      return    

    $scope.datetimeWithNoTz = $filter('clearTimezone')(moment($scope.date).format())

    $scope.minDateClean = null
    $scope.maxDateClean = null

    $scope.$watch 'minDate', (newValue, oldValue) ->
      if newValue != oldValue
        $scope.minDateClean = filterDate(newValue)

    $scope.$watch 'maxDate', (newValue, oldValue) ->
      if newValue != oldValue
        $scope.maxDateClean = filterDate(newValue)    

    filterDate = (date)->
      if date? and moment(date).isValid()
        return $filter('clearTimezone')(moment(date).format())  
      null    
