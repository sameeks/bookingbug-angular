'use strict'


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
* @param {hash}  bbResources   A hash of options
* @param {BasketItem} bbItem The BasketItem that will be updated with the selected resource. If no item is provided, bb.current_item is used as the default
* @param {boolean}  waitForService   Wait for a the service to be loaded before loading Resources
* @param {boolean}  hideDisabled   In an admin widget, disabled resources are shown by default, you can choose to hide disabled resources
* @property {array} booking_item The current basket item being referred to
* @property {array} all_resources An array of all resources
* @property {array} bookable_items An array of all BookableItems - used if the current_item has already selected a services or person
* @property {array} bookable_resources An array of Resources - used if the current_item has already selected a services or person
* @property {resource} resource The currectly selected resource
* @example
*  <example module="BB">
*    <file name="index.html">
*   <div bb-api-url='https://dev01.bookingbug.com'>
*   <div  bb-widget='{company_id:37167}'>
*     <div bb-resources>
*        <ul>
*          <li ng-repeat='resource in all_resources'> {{resource.name}}</li>
*        </ul>
*     </div>
*     </div>
*     </div>
*   </file>
*  </example>
*
####

angular.module('BB.Directives').directive 'bbResources', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ResourceList'
  link : (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbResources) or {}

    if attrs.bbItems
      scope.booking_items = scope.$eval(attrs.bbItems) or []
      scope.booking_item  = scope.booking_items[0]
    else
      scope.booking_item = scope.$eval(attrs.bbItem) or scope.bb.current_item
      scope.booking_items = [scope.booking_item]


angular.module('BB.Controllers').controller 'ResourceList', ($scope,
  $rootScope, $attrs, PageControllerService, $q, BBModel, ResourceModel,
  ValidatorService, LoadingService) ->

  loader = LoadingService.$loader($scope).notLoaded()

  angular.extend(this, new PageControllerService($scope, $q, ValidatorService, LoadingService))


  $rootScope.connection_started.then () =>
    loadData()


  loadData = () =>
    $scope.booking_item ||= $scope.bb.current_item
    # do nothing if nothing has changed
    unless ($scope.bb.steps and $scope.bb.steps[0].page == "resource_list") or $scope.options.resource_first
      if !$scope.booking_item.service or $scope.booking_item.service == $scope.change_watch_item
        # if there's no service - we have to wait for one to be set - so we're done loading for now!
        if !$scope.booking_item.service
          loader.setLoaded()
        return

    $scope.change_watch_item = $scope.booking_item.service
    loader.setLoaded()

    rpromise = BBModel.Resource.$query($scope.bb.company)
    rpromise.then (resources) =>
      if $scope.booking_item.group  # check they're part of any currently selected group
        resources = resources.filter (x) -> !x.group_id or x.group_id is $scope.booking_item.group
      $scope.all_resources = resources

    params =
      company: $scope.bb.company
      cItem: $scope.booking_item
      wait: rpromise
      item: 'resource'
    BBModel.BookableItem.$query(params).then (items) =>
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
        # if the resource has been passed into item_defaults via query string, skip to next step
        # OR if there's only one resource and single pick hasn't been enabled,
        # automatically select the resource.
        if ($scope.bb.item_defaults.resource or resources.length is 1) and !$scope.options.allow_single_pick
          if !$scope.selectItem(items[0].item, $scope.nextRoute, {skip_step: true})
            $scope.bookable_resources = resources
            $scope.bookable_items = items
        else
          $scope.bookable_resources = resources
          $scope.bookable_items = items
        loader.setLoaded()
      , (err) ->
        loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    , (err) ->
      unless err == "No service link found" and (($scope.bb.steps and $scope.bb.steps[0].page == 'resource_list') or $scope.options.resource_first)
        loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
      else
        loader.setLoaded()



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
    if $scope.resource and $scope.booking_item
      if !$scope.booking_item.resource or $scope.booking_item.resource.self != $scope.resource.self
        # only set and broadcast if it's changed
        new_resource = getItemFromResource($scope.resource)
        _.each $scope.booking_items, (item) -> item.setResource(new_resource)
        $scope.broadcastItemUpdate()
    else if newval != oldval
      _.each $scope.booking_items, (item) -> item.setResource(null)
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
      _.each $scope.booking_items, (item) -> item.setResource(new_resource)
      return true
    else
      _.each $scope.booking_items, (item) -> item.setResource(null)
      return true

