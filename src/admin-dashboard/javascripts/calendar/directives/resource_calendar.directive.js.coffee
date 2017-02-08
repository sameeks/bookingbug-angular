'use strict'

angular
  .module('BBAdminDashboard.calendar.directives')
  .directive 'bbResourceCalendar', ($compile) ->
    'ngInject'

    link = (scope, element, attrs) ->
      
      init = () ->
        addDatePickerToFCToolbar()
        return
        
      addDatePickerToFCToolbar = () ->
        uiCalElement = angular.element(document.getElementById('uicalendar'))
        datePicker = uiCalElement.find('bb-calendar-date-picker')
        if !datePicker.length
          toolbarElement = angular.element(uiCalElement.children()[0])
          toolbarLeftElement = angular.element(toolbarElement.children()[0])
          datePickerComponent = '<bb-calendar-date-picker on-change-date="vm.updateDateHandler($event)" current-date="vm.currentDate"></bb-calendar-date-picker>'
          datePickerElement = $compile(datePickerComponent)(scope)
          toolbarLeftElement.append(datePickerElement)
        return

      scope.$on 'UICalendar:EventAfterAllRender', init

      return

    return {
      controller: 'bbResourceCalendarController'
      controllerAs: 'vm'
      link: link
      templateUrl: 'calendar/resource-calendar.html'
      replace: true
      scope:
        labelAssembler: '@'
        blockLabelAssembler: '@'
        externalLabelAssembler: '@'
        model: '=?'
    }    
