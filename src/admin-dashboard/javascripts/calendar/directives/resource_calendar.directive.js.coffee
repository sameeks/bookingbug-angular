'use strict'

angular.module('BBAdminDashboard.calendar.directives').directive 'bbResourceCalendar', ($compile, $templateCache, $timeout, $rootScope) ->
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
      datePickerElement = $compile('<bb-calendar-date-picker current-date="currentDate"></bb-calendar-date-picker>')(scope)
      toolbarLeftElement.append(datePickerElement)
      return

    $rootScope.$on 'BBLanguagePicker:languageChanged', init
      
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

