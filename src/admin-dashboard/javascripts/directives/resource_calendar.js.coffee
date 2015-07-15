angular.module('BBAdminDashboard').directive 'bbResourceCalendar', (uiCalendarConfig,
    AdminCompanyService, AdminBookingService, AdminPersonService, $q) ->

  controller = ($scope) ->

    $scope.eventSources = [
      events: (start, end, timezone, callback) ->
        if $scope.company
          params =
            company: $scope.company
            start_date: start.format('YYYY-MM-DD')
            end_date: end.format('YYYY-MM-DD')
          AdminBookingService.query(params).then (bookings) ->
            b.resourceId = b.person_id for b in bookings
            console.log bookings
            callback(bookings)
    ]

    $scope.options =
      calendar:
        editable: true
        header:
          left: 'today,prev,next'
          center: 'title'
          right: 'timelineDay,agendaWeek,month'
        defaultView: 'timelineDay'
        resourceLabelText: 'Staff'
        # resources: $scope.getPeople
        resources: (callback) ->
          console.log 'get people2'
          $scope.getCompanyPromise().then (company) ->
            params = {company: company}
            AdminPersonService.query(params).then (people) ->
              $scope.people = people
              resources = for p in people
                id: p.id
                title: p.name
              uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
              callback(resources)
        # resources: [
        #   { id: 'a', title: 'Auditorium A' },
        #   { id: 'b', title: 'Auditorium B' },
        #   { id: '15283', title: 'Maria' }
        # ]

    $scope.getPeople = (callback) ->
      console.log 'get people'
      $scope.getCompanyPromise().then (company) ->
        params = {company: company}
        AdminPersonService.query(params).then (people) ->
          $scope.people = people
          resources = for p in people
            id: p.id
            title: p.name
          uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
          callback(resources)


  link = (scope, element, attrs) ->
    # unless scope.company
    #   AdminCompanyService.query(attrs).then (company) ->
    #     scope.company = company
    # $scope.getCompanyPromise().then () ->
    #   uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
    #
    scope.getCompanyPromise = () ->
      console.log 'get company promise'
      defer = $q.defer()
      if scope.company
        defer.resolve(scope.company)
      else
        AdminCompanyService.query(attrs).then (company) ->
          scope.company = company
          defer.resolve(scope.company)
      defer.promise

  {
    controller: controller
    link: link
    templateUrl: 'resource_calendar_main.html'
  }
