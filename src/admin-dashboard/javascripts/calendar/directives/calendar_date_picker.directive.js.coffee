'use strict'

angular
  .module 'BBAdminDashboard.calendar.directives'
  .directive 'bbCalendarDatePicker', () ->
    'ngInject'
    
    controller = ($scope) ->
      
      $scope.openDatePicker = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        $scope.datePickerOpened = true     
        
      $scope.$watch 'currentDate', (newDate, oldDate) ->
        if newDate != oldDate && oldDate?
          _.debounce(updateDate(newDate), 400)
        return 
      
      updateDate = (date) ->
        $scope.$emit 'datePickerUpdated', date
      
      return
  
    return {
      restrict: 'AE'
      scope: {
        currentDate: '='
      }
      controller: controller
      templateUrl: 'calendar_date_picker.html'
    }
