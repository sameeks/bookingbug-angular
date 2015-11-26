'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbAccordianRangeGroup
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of accordian range group for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbAccordianRangeGroup  A hash of options
* @property {boolean} collaspe_when_time_selected Collapse when time is selected
* @property {string} setRange Set time range for start and end
* @property {string} start_time The start time
* @property {string} end_time The end time
* @property {array} accordian_slots The accordian slots
* @property {boolean} is_open Time is open
* @property {boolean} has_availability Group has have availability
* @property {boolean} is_selected Group is selected
* @property {string} source_slots Source of slots
* @property {boolean} selected_slot Range group selected slot
* @property {boolean} hideHeading Range group hide heading
####


angular.module('BB.Directives').directive 'bbAccordianRangeGroup', () ->
  restrict: 'AE'
  replace: true
  scope: true
  require: '^?bbTimeRangeStacked'
  controller: 'AccordianRangeGroup'
  link: (scope, element, attrs, ctrl) ->
    scope.options = scope.$eval(attrs.bbAccordianRangeGroup) or {}
    scope.options.using_stacked_items = ctrl?
    scope.directives = "public.AccordianRangeGroup"


angular.module('BB.Controllers').controller 'AccordianRangeGroup',
($scope, $attrs, $rootScope, $q, FormDataStoreService) ->

  $scope.controller = "public.controllers.AccordianRangeGroup"
  $scope.collaspe_when_time_selected = true

  $rootScope.connection_started.then ->
    $scope.init($scope.options.range[0], $scope.options.range[1], $scope.options) if $scope.options and $scope.options.range

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Set form data store by id
  *
  * @param {object} id Id that sets store form data
  ###
  # store the form data for the following scope properties
  $scope.setFormDataStoreId = (id) ->
    FormDataStoreService.init ('AccordianRangeGroup'+id), $scope, []

  ###**
  * @ngdoc method
  * @name init
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Initialization of start time, end time and options
  *
  * @param {date} start_time The start time of the range group
  * @param {date} end_time The end time of the range group
  * @param {object} options The options of the range group
  ###
  $scope.init = (start_time, end_time, options) ->
    $scope.setRange(start_time, end_time)
    $scope.collaspe_when_time_selected = if options && !options.collaspe_when_time_selected then false else true

  ###**
  * @ngdoc method
  * @name setRange
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Set range of start time and end time
  *
  * @param {date} start_time The start time of the range group
  * @param {date} end_time The end time of the range group
  ###
  $scope.setRange = (start_time, end_time) ->
    if !$scope.options
      $scope.options = $scope.$eval($attrs.bbAccordianRangeGroup) or {}
    $scope.start_time = start_time
    $scope.end_time   = end_time
    setData()

  ###**
  * @ngdoc method
  * @name setData
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Set this data as ready
  ###
  setData = () ->
    $scope.accordian_slots = []
    $scope.is_open = $scope.is_open or false
    $scope.has_availability = $scope.has_availability or false
    $scope.is_selected = $scope.is_selected or false

    if $scope.options and $scope.options.slots
      $scope.source_slots = $scope.options.slots
    else if ($scope.day and $scope.day.slots)
      $scope.source_slots = $scope.day.slots
    else
      $scope.source_slots = null

    if $scope.source_slots

      if angular.isArray($scope.source_slots)
        for slot in $scope.source_slots
          $scope.accordian_slots.push(slot) if slot.time >= $scope.start_time and slot.time < $scope.end_time && slot.avail == 1
      else
        for key, slot of $scope.source_slots
          $scope.accordian_slots.push(slot) if slot.time >= $scope.start_time and slot.time < $scope.end_time && slot.avail == 1

      updateAvailability()

  ###**
  * @ngdoc method
  * @name updateAvailability
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Update availability of the slot
  *
  * @param {date} day The day of range group
  * @param {string} slot The slot of range group
  ###
  updateAvailability = (day, slot) ->   
    $scope.selected_slot = null
    $scope.has_availability = hasAvailability() if $scope.accordian_slots

    # if a day and slot has been provided, check if the slot is in range
    if day and slot
      $scope.selected_slot = slot if day.date.isSame($scope.day.date) and slot.time >= $scope.start_time and slot.time < $scope.end_time
    else 
      for slot in $scope.accordian_slots
        if slot.selected
          $scope.selected_slot = slot
          break

    if $scope.selected_slot
      $scope.hideHeading = true
      $scope.is_selected = true
      $scope.is_open = false if $scope.collaspe_when_time_selected
    else
      $scope.is_selected = false
      $scope.is_open = false if $scope.collaspe_when_time_selected      

  ###**
  * @ngdoc method
  * @name hasAvailability
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Verify if availability of accordian slots have a slot
  ###
  hasAvailability = ->
    return false if !$scope.accordian_slots
    for slot in $scope.accordian_slots
      return true if slot.availability() > 0
    return false


  $scope.$on 'slotChanged', (event, day, slot) ->  
    if day and slot
      updateAvailability(day, slot)
    else
      updateAvailability()


  $scope.$on 'dataReloaded', (event, earliest_slot) ->
    setData()

