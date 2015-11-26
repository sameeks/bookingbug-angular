'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbEventGroups
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of event groups for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {integer} total_entries The event total entries
* @property {array} events The events array
* @property {hash} filters A hash of filters
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
####


angular.module('BB.Directives').directive 'bbEventGroups', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'EventGroupList'
  link : (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbEventGroups) or {}
    scope.directives="public.EventGroupList"
    if attrs.bbItem
      scope.booking_item = scope.$eval( attrs.bbItem )
    if attrs.bbShowAll
      scope.show_all = true
    return


angular.module('BB.Controllers').controller 'EventGroupList',
($scope,  $rootScope, $q, $attrs, FormDataStoreService, ValidatorService,
  PageControllerService, halClient) ->

  $scope.controller = "public.controllers.EventGroupList"
  FormDataStoreService.init 'EventGroupList', $scope, [
    'event_group'
  ]
  $scope.notLoaded $scope
  angular.extend(this, new PageControllerService($scope, $q))

  $scope.validator = ValidatorService

  $rootScope.connection_started.then =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.init = (comp) ->
    $scope.booking_item ||= $scope.bb.current_item
    ppromise = comp.getEventGroups()

    ppromise.then (items) ->
      # not all service lists need filtering. check for attribute first
      filterItems = if $attrs.filterServices is 'false' then false else true

      if filterItems
        if $scope.booking_item.service_ref && !$scope.show_all
          items = items.filter (x) -> x.api_ref is $scope.booking_item.service_ref
        else if $scope.booking_item.category && !$scope.show_all
          # if we've selected a category for the current item - limit the list
          # of services to ones that are relevant
          items = items.filter (x) -> x.$has('category') && x.$href('category') is $scope.booking_item.category.self

      if (items.length is 1 && !$scope.allowSinglePick)
        if !$scope.selectItem(items[0], $scope.nextRoute )
          setEventGroupItem items
        else
          $scope.skipThisStep()
      else
        setEventGroupItem items

      # if there's a default - pick it and move on
      if $scope.booking_item.defaultService()
        for item in items
          if item.self == $scope.booking_item.defaultService().self
            $scope.selectItem(item, $scope.nextRoute )

      # if there's one selected - just select it
      if $scope.booking_item.event_group
        for item in items
          item.selected = false
          if item.self is $scope.booking_item.event_group.self
            $scope.event_group = item
            item.selected = true
            $scope.booking_item.setEventGroup($scope.event_group)

      $scope.setLoaded $scope

      if $scope.booking_item.event_group || (!$scope.booking_item.person && !$scope.booking_item.resource)
        # the "bookable services" are the event_group unless we've pre-selected something!
        $scope.bookable_services = $scope.items
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')



  ###**
  * @ngdoc method
  * @name setEventGroupItem
  * @methodOf BB.Directives:bbEventGroups
  * @description
  * Set event group item in accroding of items parameter
  *
  * @param {array} items Items of event group
  ###
  # set the event_group item so the correct item is displayed in the dropdown menu.
  # without doing this the menu will default to 'please select'
  setEventGroupItem = (items) ->
    $scope.items = items
    if $scope.event_group
        _.each items, (item) ->
          if item.id is $scope.event_group.id
            $scope.event_group = item

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbEventGroups
  * @description
  * Select an item from event group in according of item and route parameters
  *
  * @param {array} item The event group or BookableItem to select
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route) =>
    if $scope.$parent.$has_page_control
      $scope.event_group = item
      return false
    else
      $scope.booking_item.setEventGroup(item)
      $scope.decideNextPage(route)
      return true

  $scope.$watch 'event_group', (newval, oldval) =>
    if $scope.event_group
      if !$scope.booking_item.event_group or $scope.booking_item.event_group.self isnt $scope.event_group.self
        # only set and broadcast if it's changed
        $scope.booking_item.setEventGroup($scope.event_group)
        $scope.broadcastItemUpdate()

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbEventGroups
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () =>
    if $scope.event_group
      $scope.booking_item.setEventGroup($scope.event_group)
      return true
    else
      return false

