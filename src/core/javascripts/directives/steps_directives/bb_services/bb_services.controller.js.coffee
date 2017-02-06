BBServicesCtrl = (
  $scope, $rootScope, $q, $attrs, $uibModal, $document, $filter,
  BBModel, FormDataStoreService, PageControllerService, ErrorService, LoadingService) ->
  'ngInject'

  @$scope = $scope
  vm = @

  FormDataStoreService.init 'ServiceList', $scope, [
    'service'
  ]


  $rootScope.connection_started.then () =>
    if $scope.bb.company
      initCompany($scope.bb.company)
  , (err) -> 
    vm.loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  init = () ->
    vm.loader = LoadingService.$loader($scope).notLoaded()
    angular.extend(this, new PageControllerService($scope, $q, LoadingService))
    initOptions()
    initFilters()

    return

  initOptions = () ->
    vm.filters = 
      categoryName: null
      serviceName: null
      price: 
        min: 0
        max: 100
      customArrayValue: null


  initFilters = () ->

    $scope.showCustomArray = false

    $scope.options = $scope.$eval($attrs.bbServices) or {}

    $scope.bookingItem = $scope.$eval($attrs.bbItem) if $attrs.bbItem
    $scope.showAll = true if $attrs.bbShowAll or $scope.options.showAll
    $scope.allowSinglePick = true if $scope.options.allow_single_pick 
    $scope.hideDisabled = true if $scope.options.hideDisabled

    $scope.price_options = {min: 0, max: 100}


  initCompany = (comp) ->
    $scope.bookingItem ||= $scope.bb.current_item

    if $scope.bb.company.$has('named_categories')
      BBModel.Category.$query($scope.bb.company).then (items) =>
        $scope.all_categories = items
      , (err) ->  $scope.all_categories = []
    else
      $scope.all_categories = []

    # check any curretn service is valid for the current company
    if $scope.service && $scope.service.company_id != $scope.bb.company.id
      $scope.service = null

    promises = []

    servicePromise = comp.$getServices()

    promises.push servicePromise

    getCompanyServices(servicePromise, promises)


  getCompanyServices = (servicePromise, promises) ->
    servicePromise.then (items) =>
      readyServicesWithOptions(items)
    , (err) ->
      vm.loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


    if ($scope.bookingItem.person && !$scope.bookingItem.anyPerson()) || ($scope.bookingItem.resource && !$scope.bookingItem.anyResource())
      readyServicesWithSelectedItem(servicePromise, promises) 

    $q.all(promises).then () ->
      vm.loader.setLoaded()



  readyServicesWithOptions = (items) ->
    if $scope.options.hideDisabled
      # this might happen to ahve been an admin api call which would include disabled services - and we migth to hide them
      items = items.filter (x) -> !x.disabled && !x.deleted

    # not all service lists need filtering. check for attribute first
    filterItems = if $scope.filterServices is 'false' then false else true

    if filterItems
      if $scope.bookingItem.service_ref && !$scope.options.showAll
        items = items.filter (x) -> x.api_ref is $scope.bookingItem.service_ref
      else if $scope.bookingItem.category && !$scope.options.showAll
        # if we've selected a category for the current item - limit the list
        # of services to ones that are relevant
        items = items.filter (x) -> x.$has('category') && x.$href('category') is $scope.bookingItem.category.self

    # filter out event groups unless explicity requested
    if !$scope.options.show_event_groups
      items = items.filter (x) -> !x.is_event_group

    # if there's only one service and single pick hasn't been enabled,
    # automatically select the service.
    if (items.length is 1 && !$scope.options.allow_single_pick)
      if !$scope.selectItem(items[0], $scope.nextRoute, {skip_step: true})
        setServiceItem items
    else
      setServiceItem items

    checkIfSelectedService(items)


  checkIfSelectedService = (items) ->
    # if there's a default - pick it and move on
    if $scope.bookingItem.defaultService()
      for item in items
        if item.self == $scope.bookingItem.defaultService().self or (item.name is $scope.bookingItem.defaultService().name and !item.deleted)
          $scope.selectItem(item, $scope.nextRoute, {skip_step: true})

    # if there's one selected - just select it
    if $scope.bookingItem.service
      for item in items
        item.selected = false
        if item.self is $scope.bookingItem.service.self
          $scope.service = item
          item.selected = true
          $scope.bookingItem.setService($scope.service)

    if $scope.bookingItem.service || !(($scope.bookingItem.person && !$scope.bookingItem.anyPerson()) || ($scope.bookingItem.resource && !$scope.bookingItem.anyResource()))
      # the "bookable services" are the service unless we've pre-selected something!
      items = setServicesDisplayName(items)
      $scope.bookable_services = items

    return


  readyServicesWithSelectedItem = (servicePromise, promises) ->
    # if we've already picked a service or a resource - get a more limited service selection
    ispromise = BBModel.BookableItem.$query({company: $scope.bb.company, cItem: $scope.bookingItem, wait: servicePromise, item: 'service'})
    promises.push(ispromise)
    ispromise.then (items) =>
      if $scope.bookingItem.service_ref
        items = items.filter (x) -> x.api_ref == $scope.bookingItem.service_ref
      if $scope.bookingItem.group
        items = items.filter (x) -> !x.group_id || x.group_id == $scope.bookingItem.group

      if $scope.options.hideDisabled
        # this might happen to have been an admin api call which would include disabled services - and we migth to hide them
        items = items.filter (x) -> !x.item? || (!x.item.disabled && !x.item.deleted)

      services = (i.item for i in items when i.item?)

      services = setServicesDisplayName(services)

      $scope.bookable_services = services

      $scope.bookable_items = items

      if services.length is 1 and !$scope.options.allow_single_pick
        if !$scope.selectItem(services[0], $scope.nextRoute, {skip_step: true})
          setServiceItem services
      else
        # The ServiceModel is more relevant than the BookableItem when price and duration needs to be listed in the view pages.
        setServiceItem services

    , (err) ->
      vm.loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    return



  setServicesDisplayName = (items)->
    for item in items
      if item.listed_durations and item.listed_durations.length is 1
        item.display_name = item.name + ' - ' + $filter('time_period')(item.duration)
      else
        item.display_name = item.name

    return items


  # set the service item so the correct item is displayed in the dropdown menu.
  # without doing this the menu will default to 'please select'
  setServiceItem = (items) ->
    vm.items = items
    $scope.filtered_items = vm.items
    if $scope.service
        _.each items, (item) ->
          if item.id is $scope.service.id
            $scope.service = item

    return

  ###**
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbServices
  * @description
  * Select an item into the current booking journey and route on to the next page dpending on the current page control
  *
  * @param {object} item The Service or BookableItem to select
  * @param {string=} route A specific route to load
  ###
  $scope.selectItem = (item, route, options={}) =>

    if $scope.routed
      return true

    if $scope.$parent.$has_page_control
      $scope.service = item
      return false
    else if item.is_event_group
      $scope.bookingItem.setEventGroup(item)
      $scope.skipThisStep() if options.skip_step
      $scope.decideNextPage(route)
      $scope.routed = true
    else
      $scope.bookingItem.setService(item)
      # -----------------------------------------------------------
      $scope.bb.selected_service = $scope.bookingItem.service
      # -----------------------------------------------------------
      $scope.skipThisStep() if options.skip_step
      $scope.decideNextPage(route)
      $scope.routed = true
      return true

    return

  $scope.$watch 'service', (newval, oldval) =>
    if $scope.service && $scope.bookingItem
      if !$scope.bookingItem.service or $scope.bookingItem.service.self isnt $scope.service.self
        # only set and broadcast if it's changed
        $scope.bookingItem.setService($scope.service)
        $scope.broadcastItemUpdate()
        $scope.bb.selected_service = $scope.service

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbServices
  * @description
  * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
  ###
  setReady = () =>
    # this method is not being invoked anywhere ?
    if $scope.service
      $scope.bookingItem.setService($scope.service)
      return true
    else if $scope.bb.stacked_items and $scope.bb.stacked_items.length > 0
      return true
    else
      return false

  ###**
  * @ngdoc method
  * @name errorModal
  * @methodOf BB.Directives:bbServices
  * @description
  * Display error message in modal
  ###
  $scope.errorModal = () ->
    # this method is not being invoked anywhere ?
    error_modal = $uibModal.open
      templateUrl: $scope.getPartial('_error_modal')
      controller: ($scope, $uibModalInstance) ->
        $scope.message = ErrorService.getError('GENERIC').msg
        $scope.ok = () ->
          $uibModalInstance.close()

  ###**
  * @ngdoc method
  * @name filterFunction
  * @methodOf BB.Directives:bbServices
  * @description
  * Filter service
  ###
  $scope.filterFunction = (service) ->
    if !service
      return false
    $scope.service_array = []
    $scope.custom_array = (match)->
      if !match
        return false
      if $scope.options.custom_filter
        match = match.toLowerCase()
        for item in service.extra[$scope.options.custom_filter]
          item = item.toLowerCase()
          if item is match
            $scope.showCustomArray = true
            return true
        return false
    $scope.service_name_include = (match) ->
      if !match
        return false
      if match
        match = match.toLowerCase()
        item = service.name.toLowerCase()
        if item.includes(match)
          return true
        else
          false
    return (!vm.filters.categoryName or service.category_id is vm.filters.categoryName.id) and
      (!vm.filters.serviceName or $scope.serviceName_include(vm.filters.serviceName)) and
      (!vm.filters.customArrayValue or $scope.custom_array(vm.filters.customArrayValue)) and
      (!service.price or (service.price >= vm.filters.price.min * 100 and service.price <= vm.filters.price.max * 100 ))

  ###**
  * @ngdoc method
  * @namvm.Filters
  * @methodOf BB.Directives:bbServices
  * @description
  * Clear filters
  ###
  $scope.filters = () ->
    if $scope.options.clear_results
      $scope.showCustomArray = false
    vm.filters.categoryName = null
    vm.filters.serviceName = null
    vm.filters.price.min = 0
    vm.filters.price.max = 100
    vm.filters.customArrayValue = null

    updateFilteredItems()

  ###**
  * @ngdoc method
  * @name updateFilteredItems
  * @methodOf BB.Directives:bbServices
  * @description
  * Filter changed
  ###
  updateFilteredItems = () ->
    $scope.filtered_items = $filter('filter')(vm.items, $scope.filterFunction)


  init()

  return

angular.module('BB.Controllers').controller 'BBServicesCtrl', BBServicesCtrl
