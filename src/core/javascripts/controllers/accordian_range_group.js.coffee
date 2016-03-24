'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbAccordianRangeGroup
* @restrict AE
* @scope true
*
* @description
* Loads a list of accordian range group for the currently in scope company.
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbAccordianRangeGroup Hash options
* @property {boolean} collaspe_when_time_selected Collapse when time is selected
* @property {string} setRange Sets start and end time range
* @property {string} start_time Start time
* @property {string} end_time End time
* @property {array} accordian_slots Accordian slots
* @property {boolean} is_open Time is open
* @property {boolean} has_availability Group has availability
* @property {boolean} is_selected Group is selected
* @property {string} source_slots Slots source
* @property {boolean} selected_slot Group range selected slot
* @property {boolean} hideHeading Group range hide heading
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
  * @name setFormDataStoreId
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Stores form data by id.
  *
  * @param {object} id Id used to store form data
  ###
  # stores form data for the following scope properties
  $scope.setFormDataStoreId = (id) ->
    FormDataStoreService.init ('AccordianRangeGroup'+id), $scope, []

  ###**
  * @ngdoc method
  * @name init
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Start time, end time and options initialization.
  *
  * @param {date} start_time Group range start time
  * @param {date} end_time Group range end time
  * @param {object} options Group range options
  ###
  $scope.init = (start_time, end_time, options) ->
    $scope.setRange(start_time, end_time)
    $scope.collaspe_when_time_selected = if options && !options.collaspe_when_time_selected then false else true

  ###**
  * @ngdoc method
  * @name setRange
  * @methodOf BB.Directives:bbAccordianRangeGroup
  * @description
  * Sets start time and end time range.
  *
  * @param {date} start_time Group range start time
  * @param {date} end_time Group range end time
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
  * Sets data as ready.
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
  * Updates slot availability.
  *
  * @param {date} day Group range day
  * @param {string} slot Group range slot
  ###
  updateAvailability = (day, slot) ->
    $scope.selected_slot = null
    $scope.has_availability = hasAvailability() if $scope.accordian_slots

    # if a day and slot are provided, check if slot is in range
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
  * Verify accordian slots availability.
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
