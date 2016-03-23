angular.module('BBAdminDashboard').directive 'bbResourceCalendar', (
    uiCalendarConfig, AdminCompanyService, AdminBookingService,
    AdminPersonService, $q, $sessionStorage, ModalForm, BBModel,
    AdminBookingPopup, $window, $bbug, ColorPalette, AppConfig, Dialog,$interval,$http,
    $timeout, $compile, $templateCache, BookingCollections) ->

  controller = ($scope, $attrs) ->
    $scope.eventSources = [
      events: (start, end, timezone, callback) ->
        $scope.loading = true
        $scope.getCompanyPromise().then (company) ->
          params =
            company: company
            start_date: start.format('YYYY-MM-DD')
            end_date: end.format('YYYY-MM-DD')
          AdminBookingService.query(params).then (bookings) ->
            $scope.loading = false
            for b in bookings.items
              b.resourceId = b.person_id 
              b.useFullTime()
              b.title = labelAssembly(b)
            $scope.bookings = bookings.items
            callback($scope.bookings)
    ]

    labelAssembly = (event)->
      myRe = new RegExp("\\{([a-zA-z_-]+)\\|?([a-zA-z_-]+)?:?([a-zA-z0-9{}_-]+)?\\}", "g")

      for match,index in $scope.labelAssembler.match myRe
        console.log index
        console.log match
        parts = match.split(myRe)
        parts.splice(0,1)
        parts.pop()
        console.log parts

      event.title
      # labelParts = $scope.$eval $attrs.labelAssembler
      # if not angular.isArray labelParts
      #   event.title
      # else
      #   title = ''
      #   for part in labelParts 
      #     if event[part]?
      #       title += event[part] + ' '
      #     else
      #       title += part  + ' '

      #   title    

    $scope.options = $scope.$eval $attrs.bbResourceCalendar
    $scope.options ||= {}

    height = if $scope.options.header_height
      $bbug($window).height() - $scope.options.header_height
    else
      800

    $scope.uiCalOptions =
      calendar:
        schedulerLicenseKey: '0598149132-fcs-1443104297'
        eventStartEditable: true
        eventDurationEditable: false
        minTime: $scope.options.minTime || "09:00"
        maxTime: $scope.options.maxTime || "18:00"
        height: height
        header:
          left: 'today,prev,next'
          center: 'title'
          right: 'timelineDay,timelineDayThirty,agendaWeek,month'
        defaultView: 'timelineDay'
        views:
          agendaWeek:
            slotDuration: $scope.options.slotDuration || "00:05"
            buttonText: 'Week'
          month:
            eventLimit: 5
            buttonText: 'Month'
          timelineDay:
            slotDuration: $scope.options.slotDuration || "00:05"
            eventOverlap: false
            slotWidth: 25
            buttonText: 'Day (5m)'  
            resourceAreaWidth: '18%'
          timelineDayThirty: 
            type: 'timeline'
            slotDuration: "00:30"
            eventOverlap: false
            slotWidth: 25
            buttonText: 'Day (30m)'  
            resourceAreaWidth: '18%'
        resourceLabelText: 'Staff'
        selectable: true
        resources: (callback) ->
          $scope.getPeople(callback)
        eventDrop: (event, delta, revertFunc) ->
          Dialog.confirm
            model: event
            body: "Are you sure you want to move this booking?"
            success: (model) =>
              $scope.updateBooking(event)
            fail: () ->
              revertFunc()
        eventClick: (event, jsEvent, view) ->
          $scope.editBooking(event)
        resourceRender: (resource, resourceTDs, dataTDs) ->
          # for resourceTD in resourceTDs
          #   resourceTD.style.height = "25px"
          #   resourceTD.style.verticalAlign = "middle"
          # dataTD.style.height = "25px" for dataTD in dataTDs
        eventRender: (event, element) ->
          service = _.findWhere($scope.services, {id: event.service_id})
          if service
            element.css('background-color', service.color)
            element.css('color', service.textColor)
            element.css('border-color', service.textColor)
        eventAfterRender: (event, elements, view) ->
          # if view.type == "timelineDay"
            # element.style.height = "15px" for element in elements
          elements.draggable()
        select: (start, end, jsEvent, view, resource) ->
          view.calendar.unselect()
          rid = null
          rid = resource.id if resource
          $scope.getCompanyPromise().then (company) ->
            AdminBookingPopup.open
              item_defaults:
                date: start.format('YYYY-MM-DD')
                time: (start.hour() * 60 + start.minute())
                person: rid
              first_page: "quick_pick"
              company_id: company.id
        viewRender: (view, element) ->
          date = uiCalendarConfig.calendars.resourceCalendar.fullCalendar('getDate')
          $scope.currentDate = moment(date).format('YYYY-MM-DD')
        eventResize: (event, delta, revertFunc, jsEvent, ui, view) ->
          event.duration = event.end.diff(event.start, 'minutes')
          $scope.updateBooking(event)

    $scope.getPeople = (callback) ->
      $scope.loading = true
      $scope.getCompanyPromise().then (company) ->
        params = {company: company}
        AdminPersonService.query(params).then (people) ->
          $scope.loading = false
          $scope.people = _.sortBy people, 'name'
          p.title = p.name for p in $scope.people
          uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
          callback($scope.people)

    $scope.updateBooking = (booking) ->
      booking.person_id = booking.resourceId
      booking.$update().then (response) ->
        booking.resourceId = booking.person_id
        uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)

    $scope.editBooking = (booking) ->
      ModalForm.edit
        templateUrl: 'edit_booking_modal_form.html'
        model: booking
        title: 'Edit Booking'
        success: (response) =>
          if response.is_cancelled
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('removeEvents', [response.id])
          else
            booking.resourceId = booking.person_id
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)

    $scope.pusherSubscribe = () =>
      if $scope.company
    #    $interval () ->
    #      $http.get($scope.bb.api_url + "/api/v1/audit/bookings/?id=#{$scope.company.id}&channel_id=#{$scope.company.numeric_widget_id}").then (res) ->
    #        if res && res.data 
    #          for id in res.data
    #            console.log id
    #            booking = _.first(uiCalendarConfig.calendars.resourceCalendar.fullCalendar('clientEvents', id))
    #            if booking
    #              booking.$refetch().then () ->
    #                booking.resourceId = booking.person_id
    #                uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)
    #            else
    #              $scope.company.$get('bookings', {id: id}).then (response) ->
    #                booking = new BBModel.Admin.Booking(response)
    #                BookingCollections.checkItems(booking)
    #                $timeout ->
    #                  uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
    #                , 100
    #     , 5000

        $scope.company.pusherSubscribe((res) =>
          if res.id?
            booking = _.first(uiCalendarConfig.calendars.resourceCalendar.fullCalendar('clientEvents', res.id))
            if booking
              booking.$refetch().then () ->
                uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)
            else
              $scope.company.$get('bookings', {id: res.id}).then (response) ->
                booking = new BBModel.Admin.Booking(response)
                BookingCollections.checkItems(booking)
                uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')
        , {encrypted: false})

    $scope.openDatePicker = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        $scope.datePickerOpened = true

    $scope.updateDate = (date) ->
      if uiCalendarConfig.calendars.resourceCalendar
        uiCalendarConfig.calendars.resourceCalendar.fullCalendar('gotoDate', date)

    $scope.lazyUpdateDate = _.debounce($scope.updateDate, 400)

    $scope.datePickerOptions = {showButtonBar: false}

    $scope.$watch 'currentDate', (newDate, oldDate) ->
      $scope.lazyUpdateDate(newDate)


  link = (scope, element, attrs) ->

    scope.getCompanyPromise = () ->
      defer = $q.defer()
      if scope.company
        defer.resolve(scope.company)
      else
        AdminCompanyService.query(attrs).then (company) ->
          scope.company = company
          defer.resolve(scope.company)
      defer.promise

    scope.getCompanyPromise().then (company) ->
      company.$get('services').then (collection) ->
        collection.$get('services').then (services) ->
          scope.services = (new BBModel.Admin.Service(s) for s in services)
          ColorPalette.setColors(scope.services)

    scope.getCompanyPromise().then (company) ->
      scope.pusherSubscribe()

    $timeout () ->
      uiCalElement = angular.element(element.children()[1])
      toolbarElement = angular.element(uiCalElement.children()[0])
      toolbarLeftElement = angular.element(toolbarElement.children()[0])
      scope.currentDate = moment().format()
      datePickerElement = $compile($templateCache.get('calendar_date_picker.html'))(scope)
      toolbarLeftElement.append(datePickerElement)
    , 0

  {
    controller: controller
    link: link
    templateUrl: 'resource_calendar_main.html'
    scope :
      labelAssembler : '@'
  }
