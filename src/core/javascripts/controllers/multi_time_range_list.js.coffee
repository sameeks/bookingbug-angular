'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbTimeRangeStacked
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of time range stacked for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbTimeRangeStacked A hash of options
* @property {date} start_date The start date of time range list
* @property {date} end_date The end date of time range list
* @property {integer} available_times The available times of range list
* @property {object} day_of_week The day of week
* @property {object} selected_day The selected day from the multi time range list
* @property {object} original_start_date The original start date of range list
* @property {object} start_at_week_start The start at week start of range list
* @property {object} selected_slot The selected slot from multi time range list
* @property {object} selected_date The selected date from multi time range list
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbTimeRangeStacked', ($q, $templateCache, $compile) ->
  restrict: 'AE'
  replace: true
  scope : true
  transclude: true
  controller : 'TimeRangeListStackedController',
  link: (scope, element, attrs, controller, transclude) ->
    # focus on continue button after slot selected - for screen readers 
    scope.$on 'time:selected', ->
      btn = angular.element('#btn-continue')
      btn[0].disabled = false
      btn[0].focus()

    # date helpers
    scope.today = moment().toDate()
    scope.tomorrow = moment().add(1, 'days').toDate()

    scope.options = scope.$eval(attrs.bbTimeRangeRangeStacked) or {}

    transclude scope, (clone) =>

      # if there's content compile that or grab the week_calendar template
      has_content = clone.length > 1 || (clone.length is 1 and (!clone[0].wholeText or /\S/.test(clone[0].wholeText)))

      if has_content
        element.html(clone).show()
      else
        $q.when($templateCache.get('_week_calendar.html')).then (template) ->
          element.html(template).show()
          $compile(element.contents())(scope)


angular.module('BB.Controllers').controller 'TimeRangeListStackedController', (
  $scope, $element, $attrs, $rootScope, $q, TimeService, AlertService, BBModel,
  FormDataStoreService, PersonService, PurchaseService, DateTimeUtilitiesService,
  LoadingService) ->

  $scope.controller = "public.controllers.TimeRangeListStacked"

  FormDataStoreService.init 'TimeRangeListStacked', $scope, [
    'selected_slot'
    'original_start_date'
    'start_at_week_start'
  ]

  # show the loading icon
  loader = LoadingService.$loader($scope).notLoaded()
  $scope.available_times = 0

  $rootScope.connection_started.then ->

    # read initialisation attributes
    $scope.options = $scope.$eval($attrs.bbTimeRangeStacked) or {}


    if !$scope.time_range_length
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

    # initialise the time range
    # last selected day is set (i.e, a user has already selected a date)
    if !$scope.start_date && $scope.last_selected_date
      if $scope.original_start_date
        diff = $scope.last_selected_date.diff($scope.original_start_date, 'days')
        diff = diff % $scope.time_range_length
        diff = if diff is 0 then diff else diff + 1
        start_date = $scope.last_selected_date.clone().subtract(diff, 'days')
        setTimeRange($scope.last_selected_date, start_date)
      else
        setTimeRange($scope.last_selected_date)
    # the current item already has a date
    else if $scope.bb.stacked_items[0].date
      setTimeRange($scope.bb.stacked_items[0].date.date)
    # selected day has been provided, use this to set the time
    else if $scope.selected_day
      $scope.original_start_date = $scope.original_start_date or moment($scope.selected_day)
      setTimeRange($scope.selected_day)
    # set the time range as today
    else
      $scope.start_at_week_start = true
      setTimeRange(moment())

    $scope.loadData()


  ###**
  * @ngdoc method
  * @name setTimeRange
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Set time range in according of selected_date 
  *
  * @param {date} selected_date The selected date from multi time range list
  * @param {date} start_date The start date of range list
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

  ###**
  * @ngdoc method
  * @name add
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Add date
  *
  * @param {object} amount The selected amount
  * @param {array} type The start type
  ###
  $scope.add = (type, amount) ->
    if amount > 0
      $element.removeClass('subtract')
      $element.addClass('add')
    switch type
      when 'days'
        setTimeRange($scope.start_date.add(amount, 'days'))
      when 'weeks'
        $scope.start_date.add(amount, type)
        setTimeRange($scope.start_date)
      when 'months'
        $scope.start_date.add(amount, type).startOf('month')
        setTimeRange($scope.start_date)
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name subtract
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Subtract in according of amount and type parameters
  *
  * @param {object} amount The selected amount
  * @param {object} type The start type
  ###
  $scope.subtract = (type, amount) ->
    $scope.add(type, -amount)

  ###**
  * @ngdoc method
  * @name isSubtractValid
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Verify if the subtract is valid or not
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
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Called on datepicker date change
  ###
  # called on datepicker date change
  $scope.selectedDateChanged = () ->
    setTimeRange(moment($scope.selected_date))
    $scope.selected_slot = null
    $scope.loadData()

  ###**
  * @ngdoc method
  * @name updateHideStatus
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Update the hidden status
  ###
  updateHideStatus = () ->
    for key, day of $scope.days
      $scope.days[key].hide = !day.date.isSame($scope.selected_day,'day')


  ###**
  * @ngdoc method
  * @name isPast
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Calculate if the current earliest date is in the past - in which case we. Might want to disable going backwards
  ###
  # calculate if the current earliest date is in the past - in which case we
  # might want to disable going backwards
  $scope.isPast = () ->
    return true if !$scope.start_date
    return moment().isAfter($scope.start_date)

  ###**
  * @ngdoc method
  * @name status
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Check the status of the slot to see if it has been selected
  *
  * @param {date} day The day
  * @param {object} slot The slot of day in multi time range list
  ###
  # check the status of the slot to see if it has been selected
  # NOTE: This is very costly to call from a view, please consider using ng-class
  # to access the status
  $scope.status = (day, slot) ->
    return if !slot

    status = slot.status()
    return status

  ###**
  * @ngdoc method
  * @name highlightSlot
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Check the highlight slot
  *
  * @param {date} day The day
  * @param {object} slot The slot of day in multi time range list
  ###
  $scope.highlightSlot = (slot, day) ->

    if day and slot and slot.availability() > 0
      $scope.bb.clearStackedItemsDateTime()
      $scope.selected_slot.selected = false if $scope.selected_slot
      $scope.setLastSelectedDate(day.date)
      $scope.selected_slot = angular.copy(slot)
      $scope.selected_day  = day.date
      $scope.selected_date = day.date.toDate()

      # broadcast message to the accordion range groups
      $scope.$broadcast 'slotChanged', day, slot

      # set the date and time on the stacked items
      while slot
        for item in $scope.bb.stacked_items
          if item.service.self is slot.service.self and !item.date and !item.time
            item.setDate(day)
            item.setTime(slot)
            slot = slot.next
            break

      updateHideStatus()
      $rootScope.$broadcast "time:selected"

  ###**
  * @ngdoc method
  * @name loadData
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Load the time data
  ###
  # load the time data
  $scope.loadData = ->
    
    loader.notLoaded()


    # i have updated this to no longer depend on twixjs - but am removing for now as it breaks calendar
    # if $scope.request 
    #   if moment($scope.selected_day).isBetween($scope.request.start, $scope.request.end)
    #     updateHideStatus()
    #     loader.setLoaded() 
    #     return

    date = $scope.start_date
    edate = moment(date).add($scope.time_range_length, 'days')
    $scope.end_date = moment(edate).add(-1, 'days')

    $scope.request = {start: moment($scope.start_date), end: moment($scope.end_date)}

    pslots = []
    # group BasketItems's by their service id so that we only call the time data api once for each service
    grouped_items = _.groupBy $scope.bb.stacked_items, (item) -> item.service.id
    grouped_items = _.toArray grouped_items

    duration = $scope.bb.stacked_items[0].service.duration 

    for items in grouped_items
      pslots.push(TimeService.query({
        company: $scope.bb.company
        cItem: items[0]
        date: $scope.start_date
        end_date: $scope.end_date
        client: $scope.client
        available: 1
        duration: duration
      }))

    $q.all(pslots).then (res) ->

      $scope.data_valid = true
      $scope.days = {}

      for items, _i in grouped_items
        slots = res[_i]
        $scope.data_valid = false if !slots || slots.length == 0

        for item in items
          # splice the selected times back into the result
          spliceExistingDateTimes(item, slots)

          item.slots = {}
          for own day, times of slots
            item.slots[day] = _.indexBy(times, 'time')

      if $scope.data_valid
        for k, v of res[0]
          $scope.days[k] = ({date: moment(k)})
        setEnabledSlots()
        # updateHideStatus()
        $rootScope.$broadcast "TimeRangeListStacked:loadFinished"
      else
        # raise error
      loader.setLoaded()

    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name spliceExistingDateTimes
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Splice existing date and times
  *
  * @param {array} stacked_item The stacked item
  * @param {object} slots The slots of stacked_item from the multi_time_range_list
  ###
  spliceExistingDateTimes = (stacked_item, slots) ->

    return if !stacked_item.datetime and !stacked_item.date 
    datetime = stacked_item.datetime or DateTimeUtilitiesService.convertTimeToMoment(stacked_item.date.date, stacked_item.time.time)
    if $scope.start_date <= datetime && $scope.end_date >= datetime
      time = DateTimeUtilitiesService.convertMomentToTime(datetime)
      time_slot = _.findWhere(slots[datetime.toISODate()], {time: time})
      if !time_slot
        time_slot = stacked_item.time
        slots[datetime.toISODate()].splice(0, 0, time_slot)

      # ensure only the first time slot is marked as selected
      time_slot.selected = stacked_item.self is $scope.bb.stacked_items[0].self


  ###**
  * @ngdoc method
  * @name setEnabledSlots
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Set the enabled slots
  ###
  setEnabledSlots = () ->

    for day, day_data of $scope.days

      day_data.slots = {}

      if $scope.bb.stacked_items.length > 1

          for time, slot of $scope.bb.stacked_items[0].slots[day]

            slot = angular.copy(slot)

            isSlotValid = (slot) ->
              valid      = false
              time       = slot.time
              duration   = $scope.bb.stacked_items[0].service.duration
              next       = time + duration

              # now loop around the remaining items in the sequence looking for a slot
              for index in [1..$scope.bb.stacked_items.length-1]
                if !_.isEmpty($scope.bb.stacked_items[index].slots[day]) and $scope.bb.stacked_items[index].slots[day][next]
                  slot.next = angular.copy($scope.bb.stacked_items[index].slots[day][next])
                  slot = slot.next
                  next = next + $scope.bb.stacked_items[index].service.duration
                else
                  # invalid sequence permutation
                  return false

              return true

            # add the slot if it's valid and isn't already in the dataset
            if isSlotValid(slot)
              day_data.slots[slot.time] = slot #if !day_data.slots[slot.time]
      else

        for time, slot of $scope.bb.stacked_items[0].slots[day]
          day_data.slots[slot.time] = slot

  ###**
  * @ngdoc method
  * @name pretty_month_title
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Display pretty month title in according of month format and year format parameters
  *
  * @param {date} month_format The month format
  * @param {date} year_format The year format
  * @param {string} separator The separator is '-'
  ###
  $scope.pretty_month_title = (month_format, year_format, seperator = '-') ->
    return if !$scope.start_date
    month_year_format = month_format + ' ' + year_format
    if $scope.start_date && $scope.end_date && $scope.end_date.isAfter($scope.start_date, 'month')
      start_date = $scope.start_date.format(month_format)
      start_date = $scope.start_date.format(month_year_format) if $scope.start_date.month() == 11
      return start_date + ' ' + seperator + ' ' + $scope.end_date.format(month_year_format)
    else
      return $scope.start_date.format(month_year_format)

  ###**
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Confirm the time range stacked
  *
  * @param {string =} route A specific route to load
  * @param {object} options The options
  ###
  $scope.confirm = (route, options = {}) ->
    # first check all of the stacked items
    for item in $scope.bb.stacked_items
      if !item.time
        AlertService.add("danger", { msg: "Select a time to continue your booking" })
        return false

    # empty the current basket quickly
    $scope.bb.basket.clear()

    # add all the stacked items
    $scope.bb.pushStackToBasket()

    if options.do_not_route
      return $scope.updateBasket()
    else
      $scope.updateBasket().then ->
        loader.setLoaded()
        $scope.decideNextPage(route)
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbTimeRangeStacked
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () ->
    return $scope.confirm('', {do_not_route: true})

