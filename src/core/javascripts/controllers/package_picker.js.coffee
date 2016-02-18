'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbPackagePicker
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of package pickers for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {date} sel_date The sel date
* @property {date} selected_date The selected date
* @property {boolean} picked_time The picked time
* @property {array} timeSlots The time slots
* @property {boolean} data_valid The valid data
####




angular.module('BB.Directives').directive 'bbPackagePicker', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PackagePicker'


angular.module('BB.Controllers').controller 'PackagePicker',
($scope,  $rootScope, $q, TimeService, BBModel) ->

  $scope.controller = "public.controllers.PackagePicker"

  $scope.sel_date = moment().add(1, 'days')
  $scope.selected_date = $scope.sel_date.toDate()
  $scope.picked_time = false

  $scope.$watch 'selected_date', (newv, oldv) =>
    $scope.sel_date = moment(newv)
    $scope.loadDay()
#    $scope.$broadcast('dateChanged', moment(newv));

  ###**
  * @ngdoc method
  * @name loadDay
  * @methodOf BB.Directives:bbPackagePicker
  * @description
  * Load day
  ###
  $scope.loadDay = () =>
    $scope.timeSlots = []
    $scope.notLoaded $scope

    pslots = []
    for item in $scope.stackedItems
      pslots.push(TimeService.query({company: $scope.bb.company, cItem: item, date: $scope.sel_date, client: $scope.client }))

    $q.all(pslots).then (res) =>
      $scope.setLoaded $scope
      $scope.data_valid = true
      $scope.timeSlots = []
      for item, _i in $scope.stackedItems
        item.slots = res[_i]
        $scope.data_valid = false if !item.slots || item.slots.length == 0
        item.order = _i

      # only show times if all of the severs have availability
      if $scope.data_valid

        $scope.timeSlots = res
        # go through the items forward - to disable any start times that can't be booked for later services
        earliest = null
        for item in $scope.stackedItems
          next_earliest = null
          for slot in item.slots
            if earliest && slot.time < earliest
              slot.disable()
            else if !next_earliest
              next_earliest = slot.time + item.service.duration
          earliest = next_earliest

        # go through the items backwards - to disable any start times that can't be booked for earlier services
        latest = null
        for item in $scope.bb.stacked_items.slice(0).reverse()
          next_latest = null
          for slot in item.slots
            if latest && slot.time > latest
              slot.disable()
            else
              next_latest = slot.time - item.service.duration
          latest = next_latest
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name selectSlot
  * @methodOf BB.Directives:bbPackagePicker
  * @description
  * Select slot in according of sel_item and slot parameters
  *
  * @param {array} sel_item The sel item
  * @param {object} slot The slot
  ###
  $scope.selectSlot = (sel_item, slot) =>

    for item, count in $scope.stackedItems
      if count == sel_item.order
        item.setDate(new BBModel.Day({date: $scope.sel_date.format(), spaces: 1}))
        item.setTime(slot)
        next = slot.time + item.service.duration
        time = slot.time
        slot = null
        # if this wasnt the first item - we might need to go backwards through the previous package items - but only if they haven't already had a time picked - or it the time picked wasn't valid
        if count > 0
          current = count - 1
          while current >= 0
            item = $scope.bb.stacked_items[current]
            latest = time - item.service.duration  # the last time this service can be based on the next time (we're not accounting for gaps yet) - and the previous service duration
            if !item.time || item.time.time > latest  # if the item doesn't already have a time - or has one, but it's no longer valid for the picked new time
              # pick a new time - select the last possible time
              item.setDate(new BBModel.Day({date: $scope.sel_date.format(), spaces: 1}))
              item.setTime(null)
              for slot in item.slots
                item.setTime(slot) if slot.time < latest
            time = item.time.time
            current -= 1
      else if count > sel_item.order
        # for the last items - resort them
        slots = item.slots
        item.setDate(new BBModel.Day({date: $scope.sel_date.format(), spaces: 1}))
        if slots
          item.setTime(null)
          for slot in slots
            if slot.time >= next && !item.time
              item.setTime(slot)
              next = slot.time + item.service.duration
    $scope.picked_time = true

  ###**
  * @ngdoc method
  * @name hasAvailability
  * @methodOf BB.Directives:bbPackagePicker
  * @description
  * Checks if picker have the start time and the end time available
  *
  * @param {object} slots The slots of the package picker
  * @param {date} start_time The start time of the picker
  * @param {date} end_time The end time of the picker
  ###
  # helper function to determine if there's availability between given times,
  # returns true immediately if a time a slot is found with availability
  $scope.hasAvailability = (slots, start_time, end_time) =>

    return false if !slots

    if start_time && end_time
      # it's a time range query
      for slot in slots
        return true if slot.time >= start_time && slot.time < end_time && slot.availability() > 0

    else if end_time
      # it's a 'less than' query
      for slot in slots
        return true if slot.time < end_time && slot.availability() > 0

    else if start_time
      # it's a 'greater than' query
      for slot in slots
        return true if slot.time >= start_time && slot.availability() > 0

    else
      # check if there's availability across all slots
      for slot in slots
        return true if slot.availability() > 0



  $scope.confirm = () =>

