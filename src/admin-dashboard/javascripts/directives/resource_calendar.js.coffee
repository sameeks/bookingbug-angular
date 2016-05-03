angular.module('BBAdminDashboard').directive 'bbResourceCalendar', (
    uiCalendarConfig, AdminCompanyService, AdminBookingService,
    AdminPersonService, $q, $sessionStorage, ModalForm, BBModel,
    AdminBookingPopup, $window, $bbug, ColorPalette, AppConfig, Dialog,
    $timeout, $compile, $templateCache, BookingCollections, PrePostTime,
    AdminScheduleService, $filter) ->

  controller = ($scope, $attrs, BBAssets, ProcessAssetsFilter, $state) ->

    filters = {
      requestedAssets : ProcessAssetsFilter($state.params.assets)
    }

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
            filteredBookings = []
            for b in bookings.items
              b.resourceId = b.person_id
              b.useFullTime()
              b.title = labelAssembly(b)
              if $scope.showAll
                filteredBookings.push b
              else if not $scope.showAll and bookingBelongsToSelectedResource(b)
                filteredBookings.push b
            $scope.bookings = filteredBookings
            callback($scope.bookings)
    ,
      events: (start, end, timezone, callback) ->
        $scope.loading = true
        $scope.getCompanyPromise().then (company) ->
          AdminScheduleService.getAssetsScheduleEvents(company, start, end, !$scope.showAll, $scope.selectedResources.selected).then (availabilities) ->
            $scope.loading = false
            callback(availabilities)
    ]

    bookingBelongsToSelectedResource = (booking)->
      belongs = false
      _.each $scope.selectedResources.selected, (asset) ->
        if parseInt(asset.id) == parseInt(booking.person_id) || parseInt(asset.id) == parseInt(booking.resourceId)
          belongs = true
      return belongs

    labelAssembly = (event)->
      # if labelAssembler attribute not defined or event is "block" return the normal title
      return event.title if not $scope.labelAssembler? || event.status == 3
      # if label-assembler attr is provided it needs to be inline with the following RegExp
      #   ex: label-assembler='{service_name} - {client_name} - {created_at|date:shortTime}'
      # everything outside  {} will remain as is, inside the {} the first param (required) is the property name
      # second after the '|' (optional) is the filter and third after the ':' (optional) are the options for filter
      myRe = new RegExp("\\{([a-zA-z_-]+)\\|?([a-zA-z_-]+)?:?([a-zA-z0-9{}_-]+)?\\}", "g")

      label = $scope.labelAssembler
      for match,index in $scope.labelAssembler.match myRe
        parts = match.split(myRe)
        # Remove unnecessary empty properties of the array (first/last)
        parts.splice(0,1)
        parts.pop()

        # If requested property exists replace the placeholder with value otherwise with ''
        if event.hasOwnProperty parts[0]
          replaceWith = event[parts[0]]
          # if a filter is requested as part of the expression and filter exists
          if parts[1]? and $filter(parts[1])?
            # If filter has options as part of the expression use them
            if parts[2]?
              replaceWith = $filter(parts[1])(replaceWith, $scope.$eval(parts[2]))
            else
              replaceWith = $filter(parts[1])(replaceWith)

          label = label.replace(match, replaceWith)
        else
          label = label.replace(match, '')

      label

    $scope.options = $scope.$eval $attrs.bbResourceCalendar
    $scope.options ||= {}

    height = if $scope.options.header_height
      $bbug($window).height() - $scope.options.header_height
    else
      800

    if not $scope.options.minTime?
      $scope.options.minTime = "09:00"

    if not $scope.options.maxTime?
      $scope.options.maxTime = "18:00"

    # @todo REPLACE ALL THIS WITH VAIABLES FROM THE GeneralOptions Service
    $scope.uiCalOptions =
      calendar:
        schedulerLicenseKey: '0598149132-fcs-1443104297'
        eventStartEditable: true
        eventDurationEditable: false
        minTime: $scope.options.minTime
        maxTime: $scope.options.maxTime
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
            groupByDateAndResource: false
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
          $scope.getCalendarAssets(callback)
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
        eventRender: (event, element) ->
          # If its a blocked timeslot add colored overlay
          if event.status == 3
            element.find('.fc-bg').css({'background-color':'#000'})

          service = _.findWhere($scope.services, {id: event.service_id})
          if service
            element.css('background-color', service.color)
            element.css('color', service.textColor)
            element.css('border-color', service.textColor)
        eventAfterRender: (event, elements, view) ->
          PrePostTime.apply(event, elements, view, $scope)
          if not event.rendering? or event.rendering != 'background'
            elements.draggable()
        select: (start, end, jsEvent, view, resource) ->

          setTimeToMoment = (date, time)->
            newDate = moment(time,'HH:mm')
            newDate.set({
              'year': parseInt(date.get('year'))
              'month': parseInt(date.get('month'))
              'date': parseInt(date.get('date'))
              'second': 0
            })
            newDate

          if Math.abs(start.diff(end, 'days')) > 0
            end.subtract(1,'days')
            end = setTimeToMoment(end,$scope.options.maxTime)

          view.calendar.unselect()
          rid = null
          rid = resource.id if resource
          $scope.getCompanyPromise().then (company) ->
            AdminBookingPopup.open
              min_date: setTimeToMoment(start,$scope.options.minTime)
              max_date: setTimeToMoment(end,$scope.options.maxTime)
              from_datetime: start
              to_datetime: end
              item_defaults:
                date: start.format('YYYY-MM-DD')
                time: (start.hour() * 60 + start.minute())
                person: rid
              first_page: "quick_pick"
              company_id: company.id
        viewRender: (view, element) ->
          date = uiCalendarConfig.calendars.resourceCalendar.fullCalendar('getDate')
          $scope.currentDate = date.format()
        eventResize: (event, delta, revertFunc, jsEvent, ui, view) ->
          event.duration = event.end.diff(event.start, 'minutes')
          $scope.updateBooking(event)
        loading: (isLoading, view) ->
          $scope.calendarLoading = isLoading

    $scope.getCompanyPromise = () ->
      defer = $q.defer()
      if $scope.company
        defer.resolve($scope.company)
      else
        AdminCompanyService.query($attrs).then (company) ->
          $scope.company = company
          defer.resolve($scope.company)
      defer.promise

    # All optionassetss (resources, people) go to the same select
    $scope.assets = []
    $scope.showAll = true
    $scope.selectedResources = {
      selected: []
    }

    $scope.changeSelectedResources = ()->
      if $scope.showAll
        $scope.selectedResources.selected = []

      uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchResources')
      uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')

    $scope.getCompanyPromise().then (company) ->
      $scope.loading = true

      BBAssets(company).then((assets)->
        $scope.loading = false
        $scope.assets = assets

        # requestedAssets
        if filters.requestedAssets.length > 0
          $scope.showAll = false
          angular.forEach($scope.assets, (asset)->
            isInArray = _.find(filters.requestedAssets, (id)->
              return parseInt(id) == asset.id
            )

            if typeof isInArray != 'undefined'
              $scope.selectedResources.selected.push asset
          )

          $scope.changeSelectedResources()
      )

    $scope.$watch 'selectedResources.selected', (newValue, oldValue) ->
      if newValue != oldValue
        assets = []
        angular.forEach(newValue, (asset)->
          assets.push asset.id
        )

        params = $state.params;
        params.assets = assets.join()
        $state.go($state.current.name, params, { notify:false, reload:false});

    $scope.getCalendarAssets = (callback) ->
      $scope.loading = true

      $scope.getCompanyPromise().then (company) ->
        if $scope.showAll
          BBAssets(company).then((assets)->
            $scope.loading = false
            callback($scope.assets)
          )
        else
          $scope.loading = false
          callback($scope.selectedResources.selected)

    $scope.updateBooking = (booking) ->
      booking.person_id = booking.resourceId
      booking.$update().then (response) ->
        booking.resourceId = booking.person_id
        uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)

    $scope.editBooking = (booking) ->
      if booking.status == 3
        templateUrl = 'edit_block_modal_form.html'
        title = 'Edit Block'
      else
        templateUrl = 'edit_block_modal_form.html'
        title = 'Edit Booking'
      ModalForm.edit
        templateUrl: templateUrl
        model: booking
        title: title
        success: (response) =>
          if response.is_cancelled
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('removeEvents', [response.id])
          else
            booking.resourceId = booking.person_id
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)

    $scope.pusherSubscribe = () =>
      if $scope.company
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

    $scope.$on 'refetchBookings', () ->
      uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')

    $scope.$on 'newCheckout', () ->
      uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')

  link = (scope, element, attrs) ->

    scope.getCompanyPromise().then (company) ->
      company.$get('services').then (collection) ->
        collection.$get('services').then (services) ->
          scope.services = (new BBModel.Admin.Service(s) for s in services)
          ColorPalette.setColors(scope.services)

    scope.getCompanyPromise().then (company) ->
      scope.pusherSubscribe()

    $timeout () ->
      uiCalElement = angular.element(element.children()[2])
      toolbarElement = angular.element(uiCalElement.children()[0])
      toolbarLeftElement = angular.element(toolbarElement.children()[0])
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
