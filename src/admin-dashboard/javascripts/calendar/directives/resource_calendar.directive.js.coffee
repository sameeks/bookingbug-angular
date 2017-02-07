'use strict'

angular
  .module('BBAdminDashboard.calendar.directives')
  .directive 'bbResourceCalendar', ($compile, $timeout) ->
    'ngInject'

    link = (scope, element, attrs) ->
      
      init = () ->
        $timeout(documentReadyListener, 0)
        return

      documentReadyListener = () ->
        addDatePickerToFCToolbar()
        return

      addDatePickerToFCToolbar = () ->
        uiCalElement = angular.element(document.getElementById('uicalendar'))
        toolbarElement = angular.element(uiCalElement.children()[0])
        toolbarLeftElement = angular.element(toolbarElement.children()[0])
        datePickerComponent = '<bb-calendar-date-picker on-change-date="vm.updateDateHandler($event)" current-date="vm.currentDate"></bb-calendar-date-picker>'
        datePickerElement = $compile(datePickerComponent)(scope)
        toolbarLeftElement.append(datePickerElement)
        return

      scope.$on 'BBLanguagePicker:languageChanged', init

      init()

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

