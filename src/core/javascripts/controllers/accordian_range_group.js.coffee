'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbAccordionRangeGroup
* @restrict AE
* @scope true
*
* @description
*
* Use to group TimeSlot's by specified range for use with AngularUI Bootstrap accordion control
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbAccordionRangeGroup  A hash of options
* @property {boolean} collaspe_when_time_selected Collapse when time is selected
* @property {string} setRange Set time range for start and end
* @property {string} start_time The start time
* @property {string} end_time The end time
* @property {array} accordion_slots The accordion slots
* @property {boolean} is_open Time is open
* @property {boolean} has_availability Group has have availability
* @property {boolean} is_selected Group is selected
* @property {string} source_slots Source of slots
* @property {boolean} selected_slot Range group selected slot
* @property {boolean} hideHeading Range group hide heading
####


angular.module('BB.Directives').directive 'bbAccordionRangeGroup', (PathSvc) ->
  restrict: 'AE'
  replace: false
  scope: {
    day: '=',
    slots: '=',
    selectSlot: '='
  }
  controller: 'AccordionRangeGroup'
  link: (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbAccordionRangeGroup) or {}
  templateUrl : (element, attrs) ->
    PathSvc.directivePartial "_accordion_range_group"

angular.module('BB.Controllers').controller 'AccordionRangeGroup',
($scope, $attrs, $rootScope, $q, FormDataStoreService) ->

  $scope.controller = "public.controllers.AccordionRangeGroup"


  $scope.$watch 'slots', () ->
    setData()


  $rootScope.connection_started.then ->
    $scope.init()

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbAccordionRangeGroup
  * @description
  * Set form data store by id
  *
  * @param {object} id Id that sets store form data
  ###
  $scope.setFormDataStoreId = (id) ->
    FormDataStoreService.init ('AccordionRangeGroup'+id), $scope, []


  ###**
  * @ngdoc method
  * @name init
  * @methodOf BB.Directives:bbAccordionRangeGroup
  * @description
  * Initialization of start time, end time and options
  *
  * @param {date} start_time The start time of the range group
  * @param {date} end_time The end time of the range group
  * @param {object} options The options of the range group
  ###
  $scope.init = () ->

    $scope.start_time = $scope.options.range[0]
    $scope.end_time   = $scope.options.range[1]

    $scope.options.collaspe_when_time_selected = if _.isBoolean($scope.options.collaspe_when_time_selected) then $scope.options.collaspe_when_time_selected else true
    $scope.options.hide_availability_summary = if _.isBoolean($scope.options.hide_availability_summary) then $scope.options.hide_availability_summary else false
    $scope.heading = $scope.options.heading

    setData()


  ###**
  * @ngdoc method
  * @name setData
  * @methodOf BB.Directives:bbAccordionRangeGroup
  * @description
  * Set this data as ready
  ###
  setData = () ->

    $scope.accordion_slots = []
    $scope.is_open = $scope.is_open or false
    $scope.has_availability = $scope.has_availability or false
    $scope.is_selected = $scope.is_selected or false

    if $scope.slots

      angular.forEach $scope.slots, (slot) ->
        $scope.accordion_slots.push(slot) if slot.time >= $scope.start_time and slot.time < $scope.end_time and slot.avail is 1

      updateAvailability()


  ###**
  * @ngdoc method
  * @name updateAvailability
  * @methodOf BB.Directives:bbAccordionRangeGroup
  * @description
  * Update availability of the slot
  *
  * @param {date} day The day of range group
  * @param {string} slot The slot of range group
  ###
  updateAvailability = (day, slot) ->

    $scope.selected_slot = null
    $scope.has_availability = hasAvailability() if $scope.accordion_slots

    # if a day and slot has been provided, check if the slot is in range
    if day and slot
      $scope.selected_slot = slot if day.date.isSame($scope.day.date) and slot.time >= $scope.start_time and slot.time < $scope.end_time
    else 
      for slot in $scope.accordion_slots
        if slot.selected
          $scope.selected_slot = slot
          break

    if $scope.selected_slot
      $scope.hideHeading = true
      $scope.is_selected = true
      $scope.is_open = false if $scope.options.collaspe_when_time_selected
    else
      $scope.is_selected = false
      $scope.is_open = false if $scope.options.collaspe_when_time_selected      


  ###**
  * @ngdoc method
  * @name hasAvailability
  * @methodOf BB.Directives:bbAccordionRangeGroup
  * @description
  * Verify if availability of accordion slots have a slot
  ###
  hasAvailability = ->
    return false if !$scope.accordion_slots
    for slot in $scope.accordion_slots
      return true if slot.availability() > 0
    return false


  $scope.$on 'slotChanged', (event, day, slot) ->
    if day and slot
      updateAvailability(day, slot)
    else
      updateAvailability()
