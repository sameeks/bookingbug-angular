'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbTimeRanges
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of time rangers for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbTimeRanges A hash of options
* @property {string} selected_slot The selected slot
* @property {date} selected_date The selected date
* @property {string} postcode The postcode
* @property {date} original_start_date The original start date
* @property {date} start_at_week_start The start at week start
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbTimeRanges', () ->
  restrict: 'AE'
  replace: true
  scope : true
  priority: 1
  controller : 'TimeRangeList'


# TODO Get the add/subtract functions to respect the current time range. Get the time range length to adjust if display mode is preset
angular.module('BB.Controllers').controller 'TimeRangeList',
($scope, $element, $attrs, $rootScope, $q, TimeService, AlertService, BBModel, FormDataStoreService) ->

  $scope.controller = "public.controllers.TimeRangeList"

  # store the form data for the following scope properties
  currentPostcode = $scope.bb.postcode

  FormDataStoreService.init 'TimeRangeList', $scope, [
    'selected_slot'
    'postcode'
    'original_start_date'
    'start_at_week_start'
  ]

  # check to see if the user has changed the postcode and remove data if they have
  if currentPostcode isnt $scope.postcode
    $scope.selected_slot = null
    $scope.selected_date = null

  # store the postocde
  $scope.postcode = $scope.bb.postcode

  # show the loading icon
  $scope.notLoaded $scope

  # if the data source isn't set, set it as the current item
  if !$scope.data_source
    $scope.data_source = $scope.bb.current_item


  $rootScope.connection_started.then ->

    # read initialisation attributes
    $scope.options = $scope.$eval($attrs.bbTimeRanges) or {}

    if $attrs.bbTimeRangeLength?
      $scope.time_range_length = $scope.$eval($attrs.bbTimeRangeLength)
    else if $scope.options and $scope.options.time_range_length
      $scope.time_range_length = $scope.options.time_range_length
    else
      $scope.time_range_length = 7

    if $attrs.bbDayOfWeek? or ($scope.options and $scope.options.day_of_week)
      $scope.day_of_week = if $attrs.bbDayOfWeek? then $scope.$eval($attrs.bbDayOfWeek) else $scope.options.day_of_week

    if $attrs.bbSelectedDay? or ($scope.options and $scope.options.selected_day)
      selected_day        = if $attrs.bbSelectedDay? then moment($scope.$eval($attrs.bbSelectedDay)) else moment($scope.options.selected_day)
      $scope.selected_day = selected_day if moment.isMoment(selected_day)

    $scope.options.ignore_min_advance_datetime = if $scope.options.ignore_min_advance_datetime then true else false

    # initialise the time range
    # last selected day is set (i.e, a user has already selected a date)
    if !$scope.start_date && $scope.last_selected_date
      # if the time range list was initialised with a selected_day, restore the view so that
      # selected day remains relative to where the first day that was originally shown
      if $scope.original_start_date
        diff = $scope.last_selected_date.diff($scope.original_start_date, 'days')
        diff = diff % $scope.time_range_length
        diff = if diff is 0 then diff else diff + 1
        start_date = $scope.last_selected_date.clone().subtract(diff, 'days')
        setTimeRange($scope.last_selected_date, start_date)
      else
        setTimeRange($scope.last_selected_date)
    # the current item already has a date
    else if $scope.bb.current_item.date || $scope.bb.current_item.requested_date
      date = if $scope.bb.current_item.date then $scope.bb.current_item.date.date else $scope.bb.current_item.requested_date
      setTimeRange(date)
    # selected day has been provided, use this to set the time
    else if $scope.selected_day
      $scope.original_start_date = $scope.original_start_date or moment($scope.selected_day)
      setTimeRange($scope.selected_day)
    # set the time range as today, showing the current week
    else
      $scope.start_at_week_start = true
      setTimeRange(moment())

    $scope.loadData()

  , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name setTimeRange
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Set time range in according of selected date and start date parameters
  *
  * @param {date} selected_date The selected date
  * @param {date} start_date The start date
  ###
  setTimeRange = (selected_date, start_date) ->
    if start_date
      $scope.start_date = start_date
    else if $scope.day_of_week
      $scope.start_date = selected_date.clone().day($scope.day_of_week)
    else if $scope.start_at_week_start
      $scope.start_date = selected_date.clone().startOf('week')
    else
      $scope.start_date = selected_date.clone()

    $scope.selected_day = selected_date
    # convert selected day to JS date object for date picker, it needs
    # to be saved as a variable as functions cannot be passed into the
    # AngluarUI date picker
    $scope.selected_date = $scope.selected_day.toDate()

    isSubtractValid()

    return


  # deprecated, please use bbSelectedDay to initialise the selected_day
  $scope.init = (options = {}) ->
    if options.selected_day?
      unless options.selected_day._isAMomementObject
        $scope.selected_day = moment(options.selected_day)

  ###**
  * @ngdoc method
  * @name moment
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Add to moment date in according of date parameter
  *
  * @param {date} date The date
  ###
  $scope.moment = (date) ->
    moment(date)

  ###**
  * @ngdoc method
  * @name setDataSource
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Set data source in according of source parameter
  *
  * @param {array} source The source of data
  ###
  $scope.setDataSource = (source) ->
    $scope.data_source = source


  # when the current item is updated, reload the time data
  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name add
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Add new time range in according of type and amount parameters
  *
  * @param {object} type The type
  * @param {object} amount The amount of the days
  ###
  $scope.add = (type, amount) ->
    if amount > 0
      $element.removeClass('subtract')
      $element.addClass('add')
    $scope.selected_day = moment($scope.selected_date)
    switch type
      when 'days'
        setTimeRange($scope.selected_day.add(amount, 'days'))
      when 'weeks'
        $scope.start_date.add(amount, type)
        setTimeRange($scope.start_date)
      when 'months'
        # TODO make this advance to the next month
        $scope.start_date.add(amount, type).startOf('month')
        setTimeRange($scope.start_date)
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name subtract
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Substract amount
  *
  * @param {object} type The type
  * @param {object} amount The amount of the days
  ###
  $scope.subtract = (type, amount) ->
    $element.removeClass('add')
    $element.addClass('subtract')
    $scope.add(type, -amount)

  ###**
  * @ngdoc method
  * @name isSubtractValid
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Deprecated due to performance issues, use $scope.is_subtract_valid and $scope.subtract_length instead
  *
  * @param {object} type The type
  * @param {object} amount The amount of the days
  ###
  # deprecated due to performance issues, use $scope.is_subtract_valid and $scope.subtract_length instead
  $scope.isSubtractValid = (type, amount) ->
    return true if !$scope.start_date || $scope.isAdmin()
    date = $scope.start_date.clone().subtract(amount, type)
    return !date.isBefore(moment(), 'day')

  ###**
  * @ngdoc method
  * @name isSubtractValid
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Verify if substraction is valid
  *
  ###
  isSubtractValid = () ->
    $scope.is_subtract_valid = true

    diff = Math.ceil($scope.selected_day.diff(moment(), 'day', true))
    $scope.subtract_length = if diff < $scope.time_range_length then diff else $scope.time_range_length
    $scope.is_subtract_valid = false if diff <= 0

    if $scope.subtract_length > 1
      $scope.subtract_string = "Prev #{$scope.subtract_length} days"
    else if $scope.subtract_length is 1
      $scope.subtract_string = "Prev day"
    else
      $scope.subtract_string = "Prev"

  ###**
  * @ngdoc method
  * @name selectedDateChanged
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Select date change
  *
  ###
  # called on datepicker date change
  $scope.selectedDateChanged = () ->
    setTimeRange(moment($scope.selected_date))
    $scope.selected_slot = null
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name isPast
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Calculate if the current earliest date is in the past - in which case we might want to disable going backwards
  *
  ###
  # calculate if the current earliest date is in the past - in which case we
  # might want to disable going backwards
  $scope.isPast = () ->
    return true if !$scope.start_date
    return moment().isAfter($scope.start_date)

  ###**
  * @ngdoc method
  * @name status
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Check the status of the slot to see if it has been selected
  *
  * @param {date} day The day
  * @param {array} slot The slot
  ###
  # check the status of the slot to see if it has been selected
  # NOTE: This is very costly to call from a view, please consider using ng-class
  # to access the status
  $scope.status = (day, slot) ->
    return if !slot

    status = slot.status()
    return status
    # the view was originally calling the slot.status(). this logic below is for
    # storing the time but we're not doing this for now so we just return status
    # selected = $scope.selected_slot
    # if selected and selected.time is slot.time and selected.date is slot.date
    #   return status = 'selected'
    # return status

  ###**
  * @ngdoc method
  * @name selectSlot
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Called when user selects a time slot use this when you want to route to the next step as a slot is selected
  *
  * @param {date} day The day
  * @param {array} slot The slot
  * @param {string=} route A route of the selected slot
  ###
  # called when user selects a time slot
  # use this when you want to route to the next step as a slot is selected
  $scope.selectSlot = (day, slot, route) ->
    if slot && slot.availability() > 0
      $scope.bb.current_item.setTime(slot)

      if day
        $scope.setLastSelectedDate(day.date)
        $scope.bb.current_item.setDate(day)

      if $scope.bb.current_item.reserve_ready
        $scope.notLoaded $scope
        $scope.addItemToBasket().then () ->
          $scope.setLoaded $scope
          $scope.decideNextPage(route)
        , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
      else
        $scope.decideNextPage(route)

  ###**
  * @ngdoc method
  * @name highlightSlot
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Called when user selects a time slot use this when you just want to hightlight the the slot and not progress to the next step
  *
  * @param {date} day The day
  * @param {array} slot The slot
  ###
  # called when user selects a time slot
  # use this when you just want to hightlight the the slot and not progress to the next step
  $scope.highlightSlot = (day, slot) ->
    current_item = $scope.bb.current_item

    if slot && slot.availability() > 0
      if day
        $scope.setLastSelectedDate(day.date)
        current_item.setDate(day)

      current_item.setTime(slot)
      current_item.setDate(day)
      $scope.selected_slot = slot
      $scope.selected_day  = day.date
      $scope.selected_date = day.date.toDate()

      if $scope.bb.current_item.earliest_time_slot and $scope.bb.current_item.earliest_time_slot.selected and (!$scope.bb.current_item.earliest_time_slot.date.isSame(day.date, 'day') or $scope.bb.current_item.earliest_time_slot.time != slot.time)
        $scope.bb.current_item.earliest_time_slot.selected = false


      $rootScope.$broadcast "time:selected"
      # broadcast message to the accordian range groups
      $scope.$broadcast 'slotChanged', day, slot

  ###**
  * @ngdoc method
  * @name loadData
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Load the time data
  *
  ###
  # load the time data
  $scope.loadData = ->

    current_item = $scope.bb.current_item

    # has a service been selected?
    if current_item.service and !$scope.options.ignore_min_advance_datetime

      $scope.min_date = current_item.service.min_advance_datetime
      $scope.max_date = current_item.service.max_advance_datetime
      # if the selected day is before the services min_advance_datetime, adjust the time range
      setTimeRange(current_item.service.min_advance_datetime) if $scope.selected_day && $scope.selected_day.isBefore(current_item.service.min_advance_datetime, 'day') && !$scope.isAdmin()


    date = $scope.start_date
    edate = moment(date).add($scope.time_range_length, 'days')
    $scope.end_date = moment(edate).add(-1, 'days')

    AlertService.clear()
    # We may not want the current item duration to be the duration we query by
    # If min_duration is set, pass that into the api, else pass in the duration
    duration = $scope.bb.current_item.duration
    if $scope.bb.current_item.min_duration
      duration = $scope.bb.current_item.min_duration

    loc = null
    if $scope.bb.postcode
      loc = ",,,," + $scope.bb.postcode + ","

    if $scope.data_source && $scope.data_source.days_link
      $scope.notLoaded $scope
      loc = null
      loc = ",,,," + $scope.bb.postcode + "," if $scope.bb.postcode
      promise = TimeService.query(
        company: $scope.bb.company
        resource_ids: $scope.bb.item_defaults.resources
        cItem: $scope.data_source
        date: date
        client: $scope.client
        end_date: $scope.end_date
        duration: duration
        location: loc
        num_resources: $scope.bb.current_item.num_resources
        available: 1
      )

      promise.finally ->
        $scope.setLoaded $scope

      promise.then (datetime_arr) ->
        $scope.days = []

        # sort time slots to be in chronological order
        for pair in _.sortBy(_.pairs(datetime_arr), (pair) -> pair[0])
          d = pair[0]
          time_slots = pair[1]
          day = {date: moment(d), slots: time_slots}
          $scope.days.push(day)

          if time_slots.length > 0
            if !current_item.earliest_time || current_item.earliest_time.isAfter(d)
              current_item.earliest_time = moment(d).add(time_slots[0].time, 'minutes')
            if !current_item.earliest_time_slot || current_item.earliest_time_slot.date.isAfter(d)
              current_item.earliest_time_slot = {date: moment(d).add(time_slots[0].time, 'minutes'), time: time_slots[0].time}

          # padding is used to ensure that a list of time slots is always padded
          # out with a certain of values if it's a partial set of results
          if $scope.add_padding && time_slots.length > 0
            dtimes = {}
            for slot in time_slots
              dtimes[slot.time] = 1
              # add date to slot as well
              slot.date = day.date.format('DD-MM-YY')

            for pad, v in $scope.add_padding
              if (!dtimes[pad])
                time_slots.splice(v, 0, new BBModel.TimeSlot({time: pad, avail: 0}, time_slots[0].service))

          checkRequestedTime(day, time_slots)

      , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
    else
      $scope.setLoaded $scope

  ###**
  * @ngdoc method
  * @name checkRequestedTime
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Check requested time
  *
  * @param {date} day The day
  * @param {date} time_losts The time slots
  ###
  checkRequestedTime = (day, time_slots) ->

    current_item = $scope.bb.current_item

    if (current_item.requested_time or current_item.time) and current_item.requested_date and day.date.isSame(current_item.requested_date)
      found_time = false

      for slot in time_slots
        if (slot.time is current_item.requested_time)
          current_item.requestedTimeUnavailable()
          $scope.selectSlot(day, slot)
          found_time = true
          $scope.days = []
          return  # hey if we just picked the day and routed - then move on!

        if (current_item.time and current_item.time.time is slot.time and slot.avail is 1)
          if $scope.selected_slot and $scope.selected_slot.time isnt current_item.time.time
            $scope.selected_slot = current_item.time
          current_item.setTime(slot)  # reset it - just in case this is really a new slot!
          found_time = true

      if !found_time
        current_item.requestedTimeUnavailable()
        AlertService.raise('REQ_TIME_NOT_AVAIL')


  ###**
  * @ngdoc method
  * @name padTimes
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * The pad time
  *
  * @param {date} times The times
  ###
  $scope.padTimes = (times) ->
    $scope.add_padding = times

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () ->
    if !$scope.bb.current_item.time
      AlertService.raise('TIME_SLOT_NOT_SELECTED')
      return false
    else if $scope.bb.moving_booking && $scope.bb.current_item.start_datetime().isSame($scope.bb.current_item.original_datetime)
      AlertService.raise('APPT_AT_SAME_TIME')
      return false
    else if $scope.bb.moving_booking
      # set a 'default' person and resource if we need them, but haven't picked any in moving
      if $scope.bb.company.$has('resources') && !$scope.bb.current_item.resource
        $scope.bb.current_item.resource = true
      if $scope.bb.company.$has('people') && !$scope.bb.current_item.person
        $scope.bb.current_item.person = true
      return true
    else
      if $scope.bb.current_item.reserve_ready
        return $scope.addItemToBasket()
      else
        return true

  ###**
  * @ngdoc method
  * @name format_date
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Format the date in according of fmt parameter
  *
  * @param {date} fmt The format of date
  ###
  $scope.format_date = (fmt) ->
    $scope.start_date.format(fmt) if $scope.start_date

  ###**
  * @ngdoc method
  * @name format_start_date
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Format the start date in according of fmt parameter
  *
  * @param {date} fmt The format of start date
  ###
  $scope.format_start_date = (fmt) ->
    $scope.format_date(fmt)

  ###**
  * @ngdoc method
  * @name format_end_date
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Format the end date in according of fmt parameter
  *
  * @param {date} fmt The format of end date
  ###
  $scope.format_end_date = (fmt) ->
    $scope.end_date.format(fmt) if $scope.end_date

  ###**
  * @ngdoc method
  * @name pretty_month_title
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Format the month title in according of month formant, year format and separator parameters
  *
  * @param {date} month_format The month format
  * @param {date} year_format The year format
  * @param {object} separator The separator of month and year format
  ###
  $scope.pretty_month_title = (month_format, year_format, seperator = '-') ->
    month_year_format = month_format + ' ' + year_format
    if $scope.start_date && $scope.end_date && $scope.end_date.isAfter($scope.start_date, 'month')
      start_date = $scope.format_start_date(month_format)
      start_date = $scope.format_start_date(month_year_format) if $scope.start_date.month() == 11
      return start_date + ' ' + seperator + ' ' + $scope.format_end_date(month_year_format)
    else
      return $scope.format_start_date(month_year_format)

  ###**
  * @ngdoc method
  * @name selectEarliestTimeSlot
  * @methodOf BB.Directives:bbTimeRanges
  * @description
  * Select earliest time slot
  ###
  $scope.selectEarliestTimeSlot = () ->
    day  = _.find($scope.days, (day) -> day.date.isSame($scope.bb.current_item.earliest_time_slot.date, 'day'))
    slot = _.find(day.slots, (slot) -> slot.time is $scope.bb.current_item.earliest_time_slot.time)

    if day and slot
      $scope.bb.current_item.earliest_time_slot.selected = true
      $scope.highlightSlot(day, slot)
