angular.module('BBAdminDashboard.calendar.directives').directive 'bbResourceCalendar', (
    uiCalendarConfig, AdminCompanyService, AdminBookingService,
    AdminPersonService, $q, $sessionStorage, ModalForm, BBModel,
    AdminBookingPopup, $window, $bbug, ColorPalette, AppConfig, Dialog,
    $timeout, $compile, $templateCache, BookingCollections, PrePostTime,
    AdminScheduleService, $filter) ->

  controller = ($scope, $attrs, BBAssets, ProcessAssetsFilter, $state, GeneralOptions, AdminCalendarOptions) ->

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
            skip_cache: true
          AdminBookingService.query(params).then (bookings) ->
            $scope.loading = false
            filteredBookings = []
            for b in bookings.items
              b.resourceIds = []
              if b.person_id?
                b.resourceIds.push b.person_id + '_p'
              if b.resource_id?
                b.resourceIds.push b.resource_id + '_r'

              b.useFullTime()
              b.title = labelAssembly(b)
              b.startEditable = true if b.$has('edit')

              if $scope.showAll
                filteredBookings.push b
              else if not $scope.showAll and bookingBelongsToSelectedResource(b)
                filteredBookings.push b

            $scope.bookings = filteredBookings
            callback($scope.bookings)
    ,
      events: (start, end, timezone, callback) ->
        $scope.getCompanyPromise().then (company) ->
          if company.$has('external_bookings')
            params =
              start: start.format()
              end: end.format()
              no_cache: true
            company.$get('external_bookings', params).then (collection) ->
              collection.$get('external_bookings').then (bookings) ->
                for b in bookings
                  b.resourceIds = []
                  if b.person_id?
                    b.resourceIds.push b.person_id + '_p'
                  if b.resource_id?
                    b.resourceIds.push b.resource_id  + '_r'

                  b.type = 'external' for b in bookings
                callback(bookings)
          else
            callback([])
    ,
      events: (start, end, timezone, callback) ->
        $scope.loading = true
        $scope.getCompanyPromise().then (company) ->
          AdminScheduleService.getAssetsScheduleEvents(company, start, end, !$scope.showAll, $scope.selectedResources.selected).then (availabilities) ->

            if uiCalendarConfig.calendars.resourceCalendar.fullCalendar('getView').type == 'timelineDay'
              $scope.loading = false
              return callback(availabilities)
            else
              overAllAvailabilities = []

              angular.forEach availabilities, (availability, index)->
                dayAvailability = _.filter overAllAvailabilities, (overAllAvailability)->
                  if moment(overAllAvailability.start).dayOfYear() == moment(availability.start).dayOfYear()
                    return true
                  return false

                if dayAvailability.length > 0
                  if moment(availability.start).unix() < moment(dayAvailability[0].start).unix()
                     dayAvailability[0].start = availability.start

                  if moment(availability.end).unix() > moment(dayAvailability[0].end).unix()
                    dayAvailability[0].end = availability.end
                else
                  overAllAvailabilities.push {
                    start : availability.start
                    end : availability.end
                    rendering : "background"
                    title : "Joined availability " + moment(availability.start).format('YYYY-MM-DD')
                  }

              $scope.loading = false
              return callback(overAllAvailabilities)

    ]

    bookingBelongsToSelectedResource = (booking)->
      belongs = false
      _.each $scope.selectedResources.selected, (asset) ->
        if _.contains(booking.resourceIds, asset.id)
          belongs = true

      return belongs

    labelAssembly = (event)->
      # if labelAssembler attribute not defined or event is "block" return the normal title
      return event.title if (not $scope.labelAssembler? and event.status != 3) || (not $scope.blockLabelAssembler? and event.status == 3)
      # if label-assembler attr is provided it needs to be inline with the following RegExp
      #   ex: label-assembler='{service_name} - {client_name} - {created_at|date:shortTime}'
      # everything outside  {} will remain as is, inside the {} the first param (required) is the property name
      # second after the '|' (optional) is the filter and third after the ':' (optional) are the options for filter
      myRe = new RegExp("\\{([a-zA-z_-]+)\\|?([a-zA-z_-]+)?:?([a-zA-z0-9{}_-]+)?\\}", "g")

      if event.status == 3
        label = $scope.blockLabelAssembler
      else
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

    if not $scope.options.min_time?
      $scope.options.min_time = GeneralOptions.calendar_min_time

    if not $scope.options.max_time?
      $scope.options.max_time = GeneralOptions.calendar_max_time

    if not $scope.options.cal_slot_duration?
      $scope.options.cal_slot_duration = GeneralOptions.calendar_slot_duration

    # @todo REPLACE ALL THIS WITH VAIABLES FROM THE GeneralOptions Service
    $scope.uiCalOptions =
      calendar:
        schedulerLicenseKey: '0598149132-fcs-1443104297'
        eventStartEditable: false
        eventDurationEditable: false
        minTime: $scope.options.min_time
        maxTime: $scope.options.max_time
        height: height
        header:
          left: 'today,prev,next'
          center: 'title'
          right: 'timelineDay,timelineDayThirty,agendaWeek,month'
        defaultView: 'timelineDay'
        views:
          agendaWeek:
            slotDuration: $filter('minutesToString')($scope.options.cal_slot_duration)
            buttonText: 'Week'
            groupByDateAndResource: false
          month:
            eventLimit: 5
            buttonText: 'Month'
          timelineDay:
            slotDuration: $filter('minutesToString')($scope.options.cal_slot_duration)
            eventOverlap: false
            slotWidth: 25
            buttonText: 'Day (' + $scope.options.cal_slot_duration + 'm)'
            resourceAreaWidth: '18%'
        resourceGroupField: 'group'
        resourceLabelText: ' '
        selectable: true
        lazyFetching: false
        columnFormat: AdminCalendarOptions.column_format
        resources: (callback) ->
          getCalendarAssets(callback)
        eventDragStop: (event, jsEvent, ui, view) ->
          event.oldResourceIds = event.resourceIds
        eventDrop: (event, delta, revertFunc) ->
          Dialog.confirm
            model: event
            body: "Are you sure you want to move this booking?"
            success: (model) =>
              $scope.updateBooking(event)
            fail: () ->
              revertFunc()
        eventClick: (event, jsEvent, view) ->
          if event.$has('edit')
            $scope.editBooking(event)
        eventRender: (event, element) ->
          # If its a blocked timeslot add colored overlay
          if event.status == 3 || event.type == 'external'
            element.find('.fc-bg').css({'background-color':'#000'})

          service = _.findWhere($scope.services, {id: event.service_id})
          if service
            element.css('background-color', service.color)
            element.css('color', service.textColor)
            element.css('border-color', service.textColor)
        eventAfterRender: (event, elements, view) ->
          if not event.rendering? or event.rendering != 'background'
            PrePostTime.apply(event, elements, view, $scope)
        select: (start, end, jsEvent, view, resource) ->
          # For some reason clicking on the scrollbars triggers this event
          #  therefore we filter based on the jsEvent target
          if jsEvent.target.className == 'fc-scroller'
            return

          view.calendar.unselect()

          if isTimeRangeAvailable(start, end, resource) || Math.abs(start.diff(end, 'days'))
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
              end = setTimeToMoment(end,$scope.options.max_time)

            item_defaults =
              date: start.format('YYYY-MM-DD')
              time: (start.hour() * 60 + start.minute())

            if resource && resource.type == 'person'
              item_defaults.person = resource.id.substring(0, resource.id.indexOf('_'))
            else if resource && resource.type == 'resource'
              item_defaults.resource = resource.id.substring(0, resource.id.indexOf('_'))

            $scope.getCompanyPromise().then (company) ->
              AdminBookingPopup.open
                min_date: setTimeToMoment(start,$scope.options.min_time)
                max_date: setTimeToMoment(end,$scope.options.max_time)
                from_datetime: start
                to_datetime: end
                item_defaults: item_defaults
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

    isTimeRangeAvailable = (start, end, resource) ->
      events = uiCalendarConfig.calendars.resourceCalendar.fullCalendar('clientEvents', (event)->
        event.rendering == 'background' && start >= event.start && end <= event.end && ((resource && parseInt(event.resourceId) == parseInt(resource.id)) || !resource)
      )

      events.length > 0

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
        for asset in assets
          asset.id = asset.identifier
        $scope.loading = false
        $scope.assets = assets

        # requestedAssets
        if filters.requestedAssets.length > 0
          $scope.showAll = false
          angular.forEach($scope.assets, (asset)->
            isInArray = _.find(filters.requestedAssets, (id)->
              return id == asset.id
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

    getCalendarAssets = (callback) ->
      $scope.loading = true

      $scope.getCompanyPromise().then (company) ->
        if $scope.showAll
          BBAssets(company).then((assets)->
            for asset in assets
              asset.id = asset.identifier

            $scope.loading = false
            callback(assets)
          )
        else
          $scope.loading = false
          callback($scope.selectedResources.selected)

    $scope.updateBooking = (booking) ->
      newAssetId = booking.resourceId.substring(0, booking.resourceId.indexOf('_'))
      if booking.resourceId.indexOf('_p') > -1
        booking.person_id = newAssetId
      else if booking.resourceId.indexOf('_r') > -1
        booking.resource_id = newAssetId

      booking.$update().then (response) ->
        booking.resourceIds = []
        booking.resourceId = null
        if booking.person_id?
          booking.resourceIds.push booking.person_id + '_p'
        if booking.resource_id?
          booking.resourceIds.push booking.resource_id + '_r'

        uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)

    $scope.editBooking = (booking) ->
      if booking.status == 3
        templateUrl = 'edit_block_modal_form.html'
        title = 'Edit Block'
      else
        templateUrl = 'edit_booking_modal_form.html'
        title = 'Edit Booking'
      ModalForm.edit
        templateUrl: templateUrl
        model: booking
        title: title
        success: (response) =>
          if response.is_cancelled
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('removeEvents', [response.id])
          else
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)

    pusherBooking = (res) ->
      if res.id?
        booking = _.first(uiCalendarConfig.calendars.resourceCalendar.fullCalendar('clientEvents', res.id))
        if booking && booking.$refetch
          booking.$refetch().then () ->
            uiCalendarConfig.calendars.resourceCalendar.fullCalendar('updateEvent', booking)
        else
          uiCalendarConfig.calendars.resourceCalendar.fullCalendar('refetchEvents')

    $scope.pusherSubscribe = () =>
      if $scope.company
        pusher_channel = $scope.company.getPusherChannel('bookings')
        pusher_channel.bind 'create', pusherBooking
        pusher_channel.bind 'update', pusherBooking
        pusher_channel.bind 'destroy', pusherBooking

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
      uiCalElement = angular.element(document.getElementById('uicalendar'))
      toolbarElement = angular.element(uiCalElement.children()[0])
      toolbarLeftElement = angular.element(toolbarElement.children()[0])
      datePickerElement = $compile($templateCache.get('calendar_date_picker.html'))(scope)
      toolbarLeftElement.append(datePickerElement)
    , 0

  {
    controller: controller
    link: link
    templateUrl: 'resource_calendar_main.html'
    replace: true
    scope :
      labelAssembler : '@'
      blockLabelAssembler: '@'
  }
