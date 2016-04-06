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
* @param {boolean}  showMeridian   Switch to show/hide meridian
* @param {number}  minuteStep Step for the timepicker (optional, default:10)
###
angular.module('BBAdminBooking').directive 'bbDateTimePicker', (PathSvc) ->
  scope: 
    date: '='
    showMeridian: '='
    minuteStep: '=?'
  restrict: 'A'
  templateUrl : (element, attrs) ->
    PathSvc.directivePartial "_datetime_picker"
  controller: ($scope, $filter, $timeout) ->
    # Default minuteStep value
    $scope.minuteStep = 10 if not $scope.minuteStep or typeof $scope.minuteStep == 'undefined'

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

        $scope.date = assembledDate.format()
      return    

    $scope.datetimeWithNoTz = $filter('clearTimezone')(moment($scope.date).format())
