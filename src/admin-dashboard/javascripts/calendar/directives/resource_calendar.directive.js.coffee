'use strict'

angular.module('BBAdminDashboard.calendar.directives').directive 'bbResourceCalendar', (BBModel, ColorPalette, $timeout, $compile, $templateCache) ->
  link = (scope, element, attrs) ->
    scope.getCompanyPromise().then (company) ->
      company.$get('services').then (collection) ->
        collection.$get('services').then (services) ->
          scope.services = (new BBModel.Admin.Service(s) for s in services)
          ColorPalette.setColors(scope.services)

    scope.getCompanyPromise().then (company) ->
      scope.pusherSubscribe()

    $timeout () ->
      uiCalElement = angular.element(document.getElementById('uicalendar'))
      toolbarElement = angular.element(uiCalElement.children()[0])
      toolbarLeftElement = angular.element(toolbarElement.children()[0])
      datePickerElement = $compile($templateCache.get('calendar_date_picker.html'))(scope)
      toolbarLeftElement.append(datePickerElement)
    , 0

  return {
    controller: 'bbResourceCalendarController'
    link: link
    templateUrl: 'calendar/resource-calendar.html'
    replace: true
    scope:
      labelAssembler: '@'
      blockLabelAssembler: '@'
      externalLabelAssembler: '@'
      model: '='
  }

