angular.module('BBAdminBooking').directive 'bbDateTimePicker', (PathSvc) ->
  scope: 
  	date: '='
  restrict: 'A'
  templateUrl : (element, attrs) ->
    PathSvc.directivePartial "_datetime_picker"
  controller: ($scope, $element, $attrs, $rootScope) ->





  
