'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbTimes
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of times for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbTimes A hash of options
* @property {array} selected_day The selected day
* @property {date} selected_date The selected date
* @property {array} data_source The data source
* @property {array} item_link_source The item link source
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbTimes', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'TimeList'

angular.module('BB.Controllers').controller 'TimeList', ($attrs, $element, $scope,  $rootScope, $q, TimeService, AlertService, BBModel, DateTimeUtilitiesService) ->
  
  $scope.controller = "public.controllers.TimeList"
  $scope.notLoaded $scope

  $scope.data_source = $scope.bb.current_item if !$scope.data_source
  $scope.options = $scope.$eval($attrs.bbTimes) or {}


  $rootScope.connection_started.then ->
    
    # use default date if current item doesn't have one already
    if $scope.bb.current_item.defaults.date and !$scope.bb.current_item.date
      $scope.setDate($scope.bb.current_item.defaults.date)
      
    $scope.loadDay()

  , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  ###**
  * @ngdoc method
  * @name setDate
  * @methodOf BB.Directives:bbTimes
  * @description
  * Set the date the time list reprents
  *
  * @param {moment} the date to set the time list to use
  ###
  # set a date
  $scope.setDate = (date) =>
    day = new BBModel.Day({date: date, spaces: 1})
    $scope.selected_day  = day
    $scope.selected_date = day.date
    $scope.data_source.setDate(day)


  ###**
  * @ngdoc method
  * @name setDataSource
  * @methodOf BB.Directives:bbTimes
  * @description
  * Set data source model of time list
  *
  * @param {object} source The source
  ###
  $scope.setDataSource = (source) =>
    $scope.data_source = source

  ###**
  * @ngdoc method
  * @name setItemLinkSource
  * @methodOf BB.Directives:bbTimes
  * @description
  * Set item link source model
  *
  * @param {object} source The source
  ###
  $scope.setItemLinkSource = (source) =>
    $scope.item_link_source = source


  $scope.$on 'dateChanged', (event, newdate) =>
    $scope.setDate(newdate)
    $scope.loadDay()


  # when the current item is updated, reload the time data
  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadDay()


  ###**
  * @ngdoc method
  * @name selectSlot
  * @methodOf BB.Directives:bbTimes
  * @description
  * Select the slot from time list in according of slot and route parameters
  *
  * @param {TimeSlot} slot The slot
  * @param {string} A specific route to load
  ###
  $scope.selectSlot = (slot, route) =>
    if slot && slot.availability() > 0
      # if this time cal was also for a specific item source (i.e.a person or resoure- make sure we've selected it)
      if $scope.item_link_source
        $scope.data_source.setItem($scope.item_link_source)
      if $scope.selected_day
        $scope.setLastSelectedDate($scope.selected_day.date)
        $scope.data_source.setDate($scope.selected_day)
      $scope.data_source.setTime(slot)
      if $scope.$parent.$has_page_control
        return
      else
        if $scope.data_source.ready
          $scope.addItemToBasket().then () =>
            $scope.decideNextPage(route)
        else
          $scope.decideNextPage(route)

  ###**
  * @ngdoc method
  * @name highlightSlot
  * @methodOf BB.Directives:bbTimes
  * @description
  * The highlight slot from time list 
  *
  * @param {TimeSlot} slot The slot 
  ###
  $scope.highlightSlot = (slot) =>
    if slot && slot.availability() > 0
      if $scope.selected_day
        $scope.setLastSelectedDate($scope.selected_day.date)
        $scope.data_source.setDate($scope.selected_day)
      $scope.data_source.setTime(slot)
      # tell any accordian groups to update
      $scope.$broadcast 'slotChanged'

  ###**
  * @ngdoc method
  * @name status
  * @methodOf BB.Directives:bbTimes
  * @description
  * Check the status of the slot to see if it has been selected
  *
  * @param {date} slot The slot
  ###
  # check the status of the slot to see if it has been selected
  $scope.status = (slot) ->
    return if !slot
    status = slot.status()
    return status

  ###**
  * @ngdoc method
  * @name add
  * @methodOf BB.Directives:bbTimes
  * @description
  * Add unit of time to the selected day
  *
  * @param {date} type The type
  * @param {date} amount The amount
  ###
  # add unit of time to the selected day
  # deprecated, use bbDate directive instead
  $scope.add = (type, amount) =>
    newdate = moment($scope.data_source.date.date).add(amount, type)
    $scope.data_source.setDate(new BBModel.Day({date: newdate.format(), spaces: 0}))
    $scope.setLastSelectedDate(newdate)
    $scope.loadDay()
    $scope.$broadcast('dateChanged', newdate)

  ###**
  * @ngdoc method
  * @name subtract
  * @methodOf BB.Directives:bbTimes
  * @description
  * Subtract unit of time to the selected day
  *
  * @param {date} type The type
  * @param {date} amount The amount
  ###
  # subtract unit of time to the selected day
  # deprecated, use bbDate directive instead
  $scope.subtract = (type, amount) =>
    $scope.add(type, -amount)

  ###**
  * @ngdoc method
  * @name loadDay
  * @methodOf BB.Directives:bbTimes
  * @description
  * Load day
  ###
  $scope.loadDay = () =>

    if $scope.data_source && $scope.data_source.days_link  || $scope.item_link_source
      if !$scope.selected_date && $scope.data_source && $scope.data_source.date
        $scope.selected_date = $scope.data_source.date.date

      if !$scope.selected_date
        $scope.setLoaded $scope
        return

      $scope.notLoaded $scope
      pslots = TimeService.query({company: $scope.bb.company, cItem: $scope.data_source, item_link: $scope.item_link_source, date: $scope.selected_date.toI, client: $scope.client, available: 1 })
      
      pslots.finally ->
        $scope.setLoaded $scope
      pslots.then (time_slots) ->

        $scope.slots = time_slots
        $scope.$broadcast('slotsUpdated')
        # padding is used to ensure that a list of time slots is always padded out with a certain of values, if it's a partial set of results
        if $scope.add_padding && time_slots.length > 0
          dtimes = {}
          for s in time_slots
            dtimes[s.time] = 1

          for pad, v in $scope.add_padding
            if (!dtimes[pad])
              time_slots.splice(v, 0, new BBModel.TimeSlot({time: pad, avail: 0}, time_slots[0].service))
        
        requested_slot = DateTimeUtilitiesService.checkDefaultTime($scope.selected_date, time_slots, $scope.data_source)

        if requested_slot
          $scope.highlightSlot(requested_slot)
          $scope.skipThisStep()
          $scope.decideNextPage()

        # if ($scope.data_source.requested_time || $scope.data_source.time) && $scope.selected_date.isSame($scope.data_source.date.date)
        #   found_time = false
        #   for t in data
        #     if (t.time is $scope.data_source.requested_time)
        #       $scope.data_source.requestedTimeUnavailable()
        #       $scope.highlightSlot(t)
        #       $scope.skipThisStep()
        #       $scope.decideNextPage()
        #       found_time = true
        #       break
        # TODO why are checking this time?
        #     if ($scope.data_source.time && t.time == $scope.data_source.time.time )
        #       $scope.data_source.setTime(t)
        #       found_time = true
        #   if !found_time
        #     # if we didn't find the time - give up and do force it's selecttion
        #     $scope.data_source.requestedTimeUnavailable() if !$scope.options.persist_requested_time
        #     $scope.time_not_found = true
            # AlertService.add("danger", { msg: "Sorry, your requested time slot is not available. Please choose a different time." })
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    else
      $scope.setLoaded $scope

  ###**
  * @ngdoc method
  * @name padTimes
  * @methodOf BB.Directives:bbTimes
  * @description
  * Pad Times in according of times parameter
  *
  * @param {date} times The times
  ###
  $scope.padTimes = (times) =>
    $scope.add_padding = times

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbTimes
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () =>
    if !$scope.data_source.time
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select a time slot" })
      return false
    else
      if $scope.data_source.ready
        return $scope.addItemToBasket()
      else
        return true



# angular.module('BB.Directives').directive 'bbAccordianGroup', () ->
#   restrict: 'AE'
#   scope : true
#   controller : 'AccordianGroup'


# angular.module('BB.Controllers').controller 'AccordianGroup', ($scope,  $rootScope, $q) ->
#   $scope.accordian_slots             = []
#   $scope.is_open                     = false
#   $scope.has_availability            = false
#   $scope.is_selected                 = false
#   $scope.collaspe_when_time_selected = true
#   $scope.start_time                  = 0
#   $scope.end_time                    = 0

#   $scope.init = (start_time, end_time, options) =>

#     $scope.start_time = start_time
#     $scope.end_time   = end_time
#     $scope.collaspe_when_time_selected = if options && !options.collaspe_when_time_selected then false else true

#     for slot in $scope.slots
#       $scope.accordian_slots.push(slot) if slot.time >= start_time && slot.time < end_time

#     updateAvailability()


#   updateAvailability = () =>
#     $scope.has_availability = false

#     if $scope.accordian_slots

#       $scope.has_availability = hasAvailability()

#       # does the BasketItem's selected time reside in the accordian group?
#       item = $scope.data_source
#       if item.time && item.time.time >= $scope.start_time && item.time.time < $scope.end_time && (item.date && item.date.date.isSame($scope.selected_day.date, 'day'))
#         $scope.is_selected = true
#         $scope.is_open = true unless $scope.collaspe_when_time_selected
#       else
#         $scope.is_selected = false
#         $scope.is_open = false


#   hasAvailability = () =>
#     return false if !$scope.accordian_slots
#     for slot in $scope.accordian_slots
#       return true if slot.availability() > 0
#     return false


#   $scope.$on 'slotChanged', (event) =>
#     updateAvailability()


#   $scope.$on 'slotsUpdated', (event) =>
#     $scope.accordian_slots = []
#     for slot in $scope.slots
#       $scope.accordian_slots.push(slot) if slot.time >= $scope.start_time && slot.time < $scope.end_time
#     updateAvailability()
