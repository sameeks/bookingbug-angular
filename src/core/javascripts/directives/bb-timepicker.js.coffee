# wrapper directive around bootstrap-ui timepicker, allows us to strip timezone prior display
angular.module('BB.Directives').directive 'bbTimepicker', [ ->
  {
    restrict: 'A'
    templateUrl: 'bb-timepicker.html'
    scope:
      datetime: '='
      showMeridian: '='
    controller: [
      '$scope'
      '$filter'
      '$timeout'
      ($scope, $filter, $timeout) ->
        # Watch for changes from the datepicker
        $scope.$watch 'datetime', (newValue, oldValue) ->
          if newValue.toString() != oldValue.toString() and newValue?
            clearTimezone newValue
          return
        # Watch for changes in the timepicker and reassemble the new datetime
        $scope.$watch 'datetimeWithNoTz', (newValue, oldValue) ->
          if newValue != oldValue and newValue? and moment.utc(newValue).isValid()
            assembledDate = moment()
            assembledDate.set({
              'year': moment.utc(newValue).get 'year'
              'month': moment.utc(newValue).get 'month'
              'day': moment.utc(newValue).get 'day'
              'hour': moment.utc(newValue).get 'hour'
              'minute': moment.utc(newValue).get 'minute'
              'second': 0,
            })

            $scope.datetime = assembledDate.format()
          return   

        clearTimezone = (date)->
        	$scope.datetimeWithNoTz = $filter('clearTimezone')(moment(date).format())
        	return

        # @todo figure out why datetime is not resolved on first load
        $timeout (->
          clearTimezone $scope.datetime
          return
        ), 0

        return
    ]
    link: (scope, element, attrs) ->
      return
  }
]