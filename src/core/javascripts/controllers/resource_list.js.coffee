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
* @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a services or person
* @property {array} bookable_resources An array of Resources - used if the current_item has already selected a services or person
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

    if $attrs.bbItems
      $scope.booking_items = $scope.$eval($attrs.bbItems) or []
      $scope.booking_item  = $scope.booking_items[0]
    else
      $scope.booking_item = $scope.$eval($attrs.bbItem) or $scope.bb.current_item
      $scope.booking_items = [$scope.booking_item]

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

  
  # NOTE this gets called once, but triggers two item updates as $scope.resouce is assigned it triggers an item brodcast which means both items get updated with the result of the first item service query

  # fixing single pick wont fixd this 

  # does this affect gebneral function? i.e. when there's two resources? does the days link get screwed up in this instance? (yes, it does)

  # but the resource has the days link attached to only the first service!

  # do we need to call the item service twice over?!

  # don;t really want to complicate this directief more!
  
  # only want to show services that can be performed by both resources, two calls need to be made -

  # NO we don't - filtering list is bad, as to begin with, any resource/person for the two services is good, dont want to only show peiople that offer both services unless excplicity chosden 

  # if user uses filter, then we restruct, we shoouldn't attempt to filter the resource/person lists - always show all when we have two booking items 


  # simplify thos diretive to handle one booking item again

  # build extended version that hadnles additioanl items, querying teh item service repeatedly

  # need to wait for results to all come back, reduce list, and render this - however, want to use resource with days link attached to correct service, NOT the first one


  # want to avoid complicating this directive mroe, trying to query ItemService multuiple tiomes here will screw up the resource watch as both would try to set it

  # both items need to have the right resource selected, could in theory stop $scope.resource being set when we more than booking item, and simply use the nomrla (non bookableItem) resoure object to set teh current item?

  # again complicating standard directive....

  # want to avoud using the days link returned though as that would conflict with person i think???

  # it does

  # don't call ItemService.query where we have mroe than one booking item!!!  - we don;'t want to filter the list of resources in this instances

  # could build UI that allows person/resource to be selected for both items but complex
  # 

  filterResources = () =>

    console.log "filterresources", $scope.booking_items.length

    #return if $scope.booking_items.length > 1

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
        # OR if the resource has been passed into item_defaults and single pick hasn't been enabled,, skip to next step
        console.log "$scope.allowSinglePick", $scope.allowSinglePick

        if resources.length is 1 #and !$scope.allowSinglePick # and booking items length < 0
          resource = items[0]
        if $scope.bb.item_defaults.resource
          resource = $scope.bb.item_defaults.resource # NOTE what happens when default resource can't actually offer the service??????
        
        # NOTE selectItem item returns false when under page control
        # sets $scope.resource 
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
      _.each $scope.booking_items, (item) -> item.setResource(new_resource)
      $scope.skipThisStep() if options.skip_step
      $scope.decideNextPage(route)
      return true


  $scope.$watch 'resource',(newval, oldval) =>

    console.log "resource watch, $scope.booking_items", $scope.booking_items

    if $scope.resource and $scope.booking_item

      if !$scope.booking_item.resource or $scope.booking_item.resource.self != $scope.resource.self

        # only set and broadcast if it's changed
        new_resource = getItemFromResource($scope.resource)
        _.each $scope.booking_items, (item) -> item.setResource(new_resource)
        $scope.broadcastItemUpdate()
        console.log "resource broadcastItemUpdate 1"
    
    else if newval != oldval

      _.each $scope.booking_items, (item) -> item.setResource(null)
      $scope.broadcastItemUpdate()
      console.log "resource broadcastItemUpdate 2"



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
      _.each $scope.booking_items, (item) -> item.setResource(new_resource)
      return true
    else
      _.each $scope.booking_items, (item) -> item.setResource(null)
      return true

