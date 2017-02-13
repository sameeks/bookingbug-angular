/***
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
*/
angular.module('BB.Directives').directive('bbDateTimePicker', PathSvc =>
  ({
    scope: {
      date: '=',
      showMeridian: '=?',
      minuteStep: '=?',
      minDate: '=?',
      maxDate: '=?',
      format: '=?',
      dateOnly: '=?',
      bbDisabled: '=?'
    },
    restrict: 'A',
    templateUrl : 'bb_date_time_picker.html',
    controller($scope, $filter, $timeout, GeneralOptions) {
      if ($scope.format == null) {
        $scope.format = 'dd/MM/yyyy';
      }

      if ($scope.bbDisabled == null) {
        $scope.bbDisabled = false;
      }

      // Default minuteStep value
      if (!$scope.minuteStep || (typeof $scope.minuteStep === 'undefined')) { $scope.minuteStep = GeneralOptions.calendar_minute_step; }

      // Default showMeridian value
      if (!$scope.showMeridian || (typeof $scope.showMeridian === 'undefined')) { $scope.showMeridian = GeneralOptions.twelve_hour_format; }

      // Watch for changes in the timepicker and reassemble the new datetime
      $scope.$watch('datetimeWithNoTz', function(newValue, oldValue) {

        if ((newValue != null) && moment(newValue).isValid() && (newValue.getTime() !== oldValue.getTime())) {
          let assembledDate = moment();
          assembledDate.set({
            'year': parseInt(newValue.getFullYear()),
            'month': parseInt(newValue.getMonth()),
            'date': parseInt(newValue.getDate()),
            'hour': parseInt(newValue.getHours()),
            'minute': parseInt(newValue.getMinutes()),
            'second': 0,
            'milliseconds': 0
          });

          return $scope.date = assembledDate;
        }
      });

      let clearTimezone = function(date){
        if ((date != null) && moment(date).isValid()) {
          date = moment(date);
          let newDate = new Date();
          newDate.setFullYear(date.year());
          newDate.setMonth(date.month());
          newDate.setDate(date.date());
          newDate.setHours(date.hours());
          newDate.setMinutes(date.minutes());
          newDate.setSeconds(0);
          newDate.setMilliseconds(0);

          return newDate;
        }
        // otherwise undefined (important for timepicker)
        return undefined;
      };

      $scope.datetimeWithNoTz = clearTimezone($scope.date);

      $scope.$watch('date', function(newValue, oldValue) {
        if ((newValue !== oldValue) && (clearTimezone(newValue) !== oldValue)) {
          return $scope.datetimeWithNoTz = clearTimezone(newValue);
        }
      });

      $scope.$watch('minDate', function(newValue, oldValue) {
        if (newValue !== oldValue) {
          return $scope.minDateClean = clearTimezone(newValue);
        }
      });

      $scope.$watch('maxDate', function(newValue, oldValue) {
        if (newValue !== oldValue) {
          return $scope.maxDateClean = clearTimezone(newValue);
        }
      });

      $scope.minDateClean = clearTimezone($scope.minDate);
      return $scope.maxDateClean = clearTimezone($scope.maxDate);
    }
  })
);
