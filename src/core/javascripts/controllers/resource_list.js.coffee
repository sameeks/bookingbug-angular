'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbResources
* @restrict AE
* @scope true
*
* @description
* Loads a list of resources for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbResources A hash of options
* @param {BasketItem} bbItem The BasketItem that will be updated with the selected resource. If no item is provided, bb.current_item is used as the default
# @param {array} bbItems An array of BasketItem's that will be updated with the selected resource.
* @property {array} items An array of all resources
* @property {array} bookable_items An array of all BookableItems - use if the current_item already has a selected service or person
* @property {array} bookable_resources An array of Resources - use if the current_item has already has a selected service or person
* @property {resource} resource The currectly selected resource
####


angular.module('BB.Directives').directive 'bbResources', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ResourceList'
  link : (scope, element, attrs) ->


angular.module('BB.Controllers').controller 'ResourceList',
($scope, $attrs, $rootScope, PageControllerService, ResourceService, ItemService, $q, BBModel, ResourceModel) ->

  $scope.controller = "public.controllers.ResourceList"
  $scope.notLoaded $scope

  angular.extend(this, new PageControllerService($scope, $q))

  rpromise = null


  $rootScope.connection_started.then () ->
    init()
    

  init = () ->

    $scope.options = $scope.$eval($attrs.bbResources) or {}
    $scope.allowSinglePick = if $scope.options.allow_single_pick? then true else false

    $scope.booking_item = $scope.$eval($attrs.bbItem) or $scope.bb.current_item

    loadData()


  loadData = () =>

    # do nothing if nothing has changed
    unless ($scope.bb.steps and $scope.bb.steps[0].page == "resource_list") or $scope.options.resource_first

      if !$scope.booking_item.service or $scope.booking_item.service == $scope.change_watch_item
        # if there's no service - we have to wait for one to be set - so we're done loading for now!
        if !$scope.booking_item.service
          $scope.setLoaded $scope
        return

    $scope.change_watch_item = $scope.booking_item.service
    $scope.notLoaded $scope

    rpromise = ResourceService.query($scope.bb.company)

    rpromise.then (resources) ->

      if $scope.booking_item.group  # check they're part of any currently selected group
        resources = resources.filter (x) -> !x.group_id or x.group_id is $scope.booking_item.group
      $scope.all_resources = resources

      $scope.setLoaded $scope

    filterResources()


  filterResources = () =>

    $scope.notLoaded $scope

    params =
      company: $scope.bb.company
      cItem: $scope.booking_item
      wait: rpromise
      item: 'resource'

    ItemService.query(params).then (items) =>

      promises = []

      if $scope.booking_item.group # check they're part of any currently selected group
        items = items.filter (x) -> !x.group_id or x.group_id is $scope.booking_item.group

      for i in items
        promises.push(i.promise)

      $q.all(promises).then (res) =>
        resources = []
        for i in items
          resources.push(i.item)
          if $scope.booking_item and $scope.booking_item.resource and $scope.booking_item.resource.id is i.item.id
            # set the resource unless the resource was automatically set
            $scope.resource = i.item if $scope.bb.current_item.settings.resource isnt -1
        
        # if there's only one resource and single pick hasn't been enabled,
        # automatically select the resource.
        # OR if the resource has been passed into item_defaults and single pick hasn't been enabled,skip to next step

        if resources.length is 1 and !$scope.allowSinglePick
          resource = items[0]
        if $scope.bb.item_defaults.resource
          resource = $scope.bb.item_defaults.resource # NOTE what happens when default resource can't actually offer the service?
        
        if resource and !$scope.selectItem(resource.item, $scope.nextRoute, {skip_step: true})
          $scope.bookable_resources = resources
          $scope.bookable_items = items
        else
          $scope.bookable_resources = resources
          $scope.bookable_items = items

        $scope.setLoaded $scope
      , (err) ->
        $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
    , (err) ->
      unless err is "No service link found" and (($scope.bb.steps and $scope.bb.steps[0].page is 'resource_list') or $scope.options.resource_first)
        $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
      else
        $scope.setLoaded $scope


  ###**
  * @ngdoc method
  * @name getItemFromResource
  * @methodOf BB.Directives:bbResources
  * @description
  * Get item from resource in according of resource parameter
  *
  * @param {object} resource The resource
  ###
  getItemFromResource = (resource) =>
    if (resource instanceof  ResourceModel)
      if $scope.bookable_items
        for item in $scope.bookable_items
          if item.item.self == resource.self
            return item
    return resource


  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbResources
  * @description
  * Select an item into the current booking journey and route on to the next page dpending on the current page control
  *
  * @param {array} item The Service or BookableItem to select
  * @param {string=} route A specific route to load
  * @param {string=} skip_step The skip_step has been set to false
  ###
  $scope.selectItem = (item, route, options={}) =>
    
    if $scope.$parent.$has_page_control
      $scope.resource = item
      return false
    else
      new_resource = getItemFromResource(item)
      $scope.booking_item.setResource(new_resource)
      $scope.skipThisStep() if options.skip_step
      $scope.decideNextPage(route)
      return true


  $scope.$watch 'resource',(newval, oldval) =>

    if $scope.resource and $scope.booking_item

      if !$scope.booking_item.resource or $scope.booking_item.resource.self != $scope.resource.self

        # only set and broadcast if it's changed
        new_resource = getItemFromResource($scope.resource)
        $scope.booking_item.setResource(new_resource)
        $scope.broadcastItemUpdate()
    
    else if newval != oldval

      $scope.booking_item.setResource(null)
      $scope.broadcastItemUpdate()


  $scope.$on "currentItemUpdate", (event) ->
    loadData()


    ###**
    * @ngdoc method
    * @name setReady
    * @methodOf BB.Directives:bbResources
    * @description
    * Set this page section as ready
    ###
   $scope.setReady = () =>
    if $scope.resource
      new_resource = getItemFromResource($scope.resource)
      $scope.booking_item.setResource(new_resource)
      return true
    else
      $scope.booking_item.setResource(null)
      return true

