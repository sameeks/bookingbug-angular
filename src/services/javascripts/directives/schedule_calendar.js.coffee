angular.module('BBAdminServices').directive 'scheduleCalendar', (uiCalendarConfig, ScheduleRules) ->

  controller = ($scope, $attrs) ->

    $scope.eventSources = [
      events: (start, end, timezone, callback) ->
        console.log 'events '
        callback($scope.getEvents())
    ]

    $scope.getCalendarEvents = (start, end) ->
      events = uiCalendarConfig.calendars.scheduleCal.fullCalendar('clientEvents',
        (e) ->
          (start.isAfter(e.start) || start.isSame(e.start)) &&
            (end.isBefore(e.end) || end.isSame(e.end)))

    options = $scope.$eval($attrs.scheduleCalendar) or {}

    $scope.options =
      calendar:
        editable: false
        selectable: true
        defaultView: 'agendaWeek'
        header:
          left: 'today,prev,next'
          center: 'title'
          right: 'month,agendaWeek'
        selectHelper: false
        eventOverlap: false
        lazyFetching: false
        views:
          agendaWeek:
            allDaySlot: false
            slotEventOverlap: false
            minTime: options.min_time || '00:00:00'
            maxTime: options.max_time || '24:00:00'
            noEventClick: true
        select: (start, end, jsEvent, view) ->
          console.log 'select'
          events = $scope.getCalendarEvents(start, end)
          console.log 'events ', events
          if events.length > 0
            $scope.removeRange(start, end)
          else
            console.log 'add range ', start, end
            $scope.addRange(start, end)
        eventResizeStop: (event, jsEvent, ui, view) ->
          $scope.addRange(event.start, event.end)
        eventDrop: (event, delta, revertFunc, jsEvent, ui, view) ->
          if event.start.hasTime()
            orig =
              start: moment(event.start).subtract(delta)
              end: moment(event.end).subtract(delta)
            $scope.removeRange(orig.start, orig.end)
            $scope.addRange(event.start, event.end)

    $scope.render = () ->
      uiCalendarConfig.calendars.scheduleCal.fullCalendar('render')


  link = (scope, element, attrs, ngModel) ->

    scheduleRules = () ->
      new ScheduleRules(ngModel.$viewValue)

    scope.getEvents = () ->
      console.log 'getEvents'
      x = scheduleRules().toEvents()
      console.log x
      x

    scope.addRange = (start, end) ->
      ngModel.$setViewValue(scheduleRules().addRange(start, end))
      console.log ngModel.$viewValue
      ngModel.$render()

    scope.removeRange = (start, end) ->
      ngModel.$setViewValue(scheduleRules().removeRange(start, end))
      ngModel.$render()

    scope.toggleRange = (start, end) ->
      ngModel.$setViewValue(scheduleRules().toggleRange(start, end))
      ngModel.$render()

    ngModel.$render = () ->
      console.log 'render'
      if uiCalendarConfig && uiCalendarConfig.calendars.scheduleCal
        console.log 'refetch events'
        uiCalendarConfig.calendars.scheduleCal.fullCalendar('refetchEvents')
        uiCalendarConfig.calendars.scheduleCal.fullCalendar('unselect')
      else
        console.log 'missing scheduleCal'

    scope.calendar = uiCalendarConfig.calendars.scheduleCal

  {
    controller: controller
    link: link
    templateUrl: 'schedule_cal_main.html'
    require: 'ngModel'
    scope:
      render: '=?'
  }
