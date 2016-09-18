'use strict'

angular.module('BB.Directives').directive 'bbAdminCalendar', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'adminCalendarCtrl'

angular.module('BB.Controllers').controller 'adminCalendarCtrl', ($scope, $element,
  $controller, $attrs, BBModel, $rootScope) ->

  angular.extend(this, $controller('TimeList', {
    $scope: $scope,
    $attrs: $attrs,
    $element: $element
  }))

  $scope.calendar_view = {
    next_available: false,
    day: false,
    multi_day: false
  }

  $rootScope.connection_started.then ->
    $scope.initialise()

  $scope.initialise = () ->
    # set default view
    if $scope.bb.item_defaults.pick_first_time
      $scope.switchView('next_available')
    else if $scope.bb.current_item.defaults.time?
      $scope.switchView('day')
    else
      $scope.switchView($scope.bb.item_defaults.day_view or 'multi_day')

    $scope.person_name   = $scope.bb.current_item.person.name if $scope.bb.current_item.person
    $scope.resource_name = $scope.bb.current_item.resource.name if $scope.bb.current_item.resource


  $scope.switchView = (view) ->

    if view == "day"
      if $scope.slots and $scope.bb.current_item.time
        for slot in $scope.slots
          if slot.time == $scope.bb.current_item.time.time
            $scope.highlightSlot(slot, $scope.bb.current_item.date)
            break

    # reset views
    for key, value of $scope.calendar_view
      $scope.calendar_view[key] = false

    # set new view
    $scope.calendar_view[view] = true


  $scope.pickTime = (slot) ->
    $scope.bb.current_item.setTime(slot)
    if $scope.bb.current_item.reserve_ready
      $scope.addItemToBasket().then () =>
        $scope.decideNextPage()
    else
      $scope.decideNextPage()

  $scope.pickOtherTime = () ->
    $scope.availability_conflict = false

  $scope.setCloseBookings = (bookings) ->
    $scope.other_bookings = bookings


  $scope.overBook = () ->

    new_timeslot = new BBModel.TimeSlot({time: $scope.bb.current_item.defaults.time, avail: 1})
    new_day = new BBModel.Day({date: $scope.bb.current_item.defaults.datetime, spaces: 1})

    $scope.setLastSelectedDate(new_day.date)
    $scope.bb.current_item.setDate(new_day)

    $scope.bb.current_item.setTime(new_timeslot)

    $scope.bb.current_item.setPerson($scope.bb.current_item.defaults.person)
    $scope.bb.current_item.setResource($scope.bb.current_item.defaults.resource)

    if $scope.bb.current_item.reserve_ready
      $scope.addItemToBasket().then () =>
        $scope.decideNextPage()
    else
      $scope.decideNextPage()

angular.module('BB.Directives').directive 'bbAdminCalendarConflict', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : ($scope, $element, $controller, $attrs, BBModel, $rootScope) ->



    time = $scope.bb.current_item.defaults.time
    duration = $scope.bb.current_item.duration
    end_time = time + $scope.bb.current_item.duration


    start_datetime = $scope.bb.current_item.defaults.datetime

    # caclulate the max and min time we need to book around based on the service pre and post time
    service = $scope.bb.current_item.service
    min_time = start_datetime.clone().add(-(service.pre_time  || 0), 'minutes')
    max_time = start_datetime.clone().add(duration + (service.post_time  || 0), 'minutes')

    st = time - 30
    en = time + duration + 30

    ibest_earlier = 0
    ibest_later = 0

    $scope.allow_overbook = $scope.bb.company.settings.has_overbook

    if $scope.slots
      for slot in $scope.slots
        if time > slot.time
          ibest_earlier = slot.time
          $scope.best_earlier = slot
        if ibest_later == 0 && slot.time > time
          ibest_later = slot.time
          $scope.best_later = slot

    # I actaully think this time is available - just it's not on a schedule step that matches
    if ibest_earlier > 0 && ibest_later > 0 && ibest_earlier > time - duration && ibest_later < time + duration
      $scope.step_mismatch = true

    $scope.checking_conflicts = true
    params =
      src     : $scope.bb.company
      person_id : $scope.bb.current_item.defaults.person.id if $scope.bb.current_item.defaults.person
      resource_id : $scope.bb.current_item.defaults.resource_id if $scope.bb.current_item.defaults.resource
      start_date : $scope.bb.current_item.defaults.datetime.format('YYYY-MM-DD')
      start_time : sprintf("%02d:%02d",st/60, st%60)
      end_time   : sprintf("%02d:%02d",en/60, en%60)
    BBModel.Admin.Booking.$query(params).then (bookings) ->
      if bookings.items.length > 0
        $scope.nearby_bookings = _.filter bookings.items, (x) -> 
          (($scope.bb.current_item.defaults.person && x.person_id == $scope.bb.current_item.defaults.person.id) || ($scope.bb.current_item.defaults.resources && x.resources_id == $scope.bb.current_item.defaults.resources.id))
        $scope.overlapping_bookings = _.filter $scope.nearby_bookings, (x) ->
          b_st = x.datetime.clone().subtract(-(x.pre_time || 0), "minutes")
          b_en = x.end_datetime.clone().subtract((x.post_time || 0), "minutes")
          (b_st.isBefore(max_time)) && (b_en.isAfter(min_time))        
        $scope.nearby_bookings = false if $scope.nearby_bookings.length == 0
        $scope.overlapping_bookings = false if $scope.overlapping_bookings.length == 0

      if !$scope.overlapping_bookings && $scope.bb.company.$has('external_bookings') # no overlappying bookings - try external bookings
        params =
          start    : $scope.bb.current_item.defaults.datetime.format('YYYY-MM-DD')
          end      : $scope.bb.current_item.defaults.datetime.clone().add(1, 'day').format('YYYY-MM-DD')
          person_id : $scope.bb.current_item.defaults.person.id if $scope.bb.current_item.defaults.person
          resource_id : $scope.bb.current_item.defaults.resource_id if $scope.bb.current_item.defaults.resource
        $scope.bb.company.$get('external_bookings', params).then (collection) ->
          bookings = collection.external_bookings
          if bookings && bookings.length > 0
            $scope.external_bookings = _.filter bookings, (x) -> 
              x.start_time = moment(x.start)
              x.end_time = moment(x.end)
              x.title ||= "Blocked"
              (x.start_time.isBefore(max_time)) && (x.end_time.isAfter(min_time))        

      $scope.checking_conflicts = false
    , (err) ->
      $scope.checking_conflicts = false

