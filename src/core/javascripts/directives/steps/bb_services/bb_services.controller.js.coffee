BBServicesCtrl = ($localStorage, $scope, $rootScope, $q, $attrs, $uibModal, $document, BBModel, FormDataStoreService, ValidatorService, ErrorService, $filter, LoadingService) ->
  'ngInject'

  @$scope = $scope

  store = $localStorage.getObject('bb')

  FormDataStoreService.init 'ServiceList', $scope, [
    'service'
  ]

  loader = LoadingService.$loader($scope).notLoaded()

  $scope.filters = {category_name: null, service_name: null, price: { min: 0, max: 100}, custom_array_value: null}
  $scope.show_custom_array = false

  $scope.options = $scope.$eval($attrs.bbServices) or {}

  $scope.booking_item = $scope.$eval($attrs.bbItem) if $attrs.bbItem
  $scope.show_all = true if $attrs.bbShowAll or $scope.options.show_all
  $scope.allowSinglePick = true if $scope.options.allow_single_pick
  $scope.hide_disabled = true if $scope.options.hide_disabled

  $scope.price_options = {min: 0, max: 100}

  $rootScope.connection_started.then () =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) -> loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.init = (comp) ->
    $scope.booking_item ||= $scope.bb.current_item

    if $scope.bb.company.$has('named_categories')
      BBModel.Category.$query($scope.bb.company).then (items) =>
        $scope.all_categories = items
      , (err) ->  $scope.all_categories = []
    else
      $scope.all_categories = []

    # check any curretn service is valid for the current company
    if $scope.service && $scope.service.company_id != $scope.bb.company.id
      $scope.service = null

    ppromise = comp.$getServices()

    all_loaded = [ppromise]

    ppromise.then (items) =>
      if $scope.options.hide_disabled
        # this might happen to ahve been an admin api call which would include disabled services - and we migth to hide them
        items = items.filter (x) -> !x.disabled && !x.deleted

      # not all service lists need filtering. check for attribute first
      filterItems = if $attrs.filterServices is 'false' then false else true

      if filterItems
        if $scope.booking_item.service_ref && !$scope.options.show_all
          items = items.filter (x) -> x.api_ref is $scope.booking_item.service_ref
        else if $scope.booking_item.category && !$scope.options.show_all
          # if we've selected a category for the current item - limit the list
          # of services to ones that are relevant
          items = items.filter (x) -> x.$has('category') && x.$href('category') is $scope.booking_item.category.self

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

      # if there's a default - pick it and move on
      if $scope.booking_item.defaultService()
        for item in items
          if item.self == $scope.booking_item.defaultService().self or (item.name is $scope.booking_item.defaultService().name and !item.deleted)
            $scope.selectItem(item, $scope.nextRoute, {skip_step: true})

      # if there's one selected - just select it
      if $scope.booking_item.service
        for item in items
          item.selected = false
          if item.self is $scope.booking_item.service.self
            $scope.service = item
            item.selected = true
            $scope.booking_item.setService($scope.service)

      if $scope.booking_item.service || !(($scope.booking_item.person && !$scope.booking_item.anyPerson()) || ($scope.booking_item.resource && !$scope.booking_item.anyResource()))
        # the "bookable services" are the service unless we've pre-selected something!
        items = setServicesDisplayName(items)
        $scope.bookable_services = items
    , (err) ->
      loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    if ($scope.booking_item.person && !$scope.booking_item.anyPerson()) || ($scope.booking_item.resource && !$scope.booking_item.anyResource())
      # if we've already picked a service or a resource - get a more limited service selection
      ispromise = BBModel.BookableItem.$query({company: $scope.bb.company, cItem: $scope.booking_item, wait: ppromise, item: 'service'})
      all_loaded.push(ispromise)
      ispromise.then (items) =>
        if $scope.booking_item.service_ref
          items = items.filter (x) -> x.api_ref == $scope.booking_item.service_ref
        if $scope.booking_item.group
          items = items.filter (x) -> !x.group_id || x.group_id == $scope.booking_item.group

        if $scope.options.hide_disabled
          # this might happen to ahve been an admin api call which would include disabled services - and we migth to hide them
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
        loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    $q.all(all_loaded).then () ->
      loader.setLoaded()


  setServicesDisplayName = (items)->
    for item in items
      if item.listed_durations and item.listed_durations.length is 1
        item.display_name = item.name + ' - ' + $filter('time_period')(item.duration)
      else
        item.display_name = item.name

    items


  # set the service item so the correct item is displayed in the dropdown menu.
  # without doing this the menu will default to 'please select'
  setServiceItem = (items) ->
    $scope.items = items
    $scope.filtered_items = $scope.items
    if $scope.service
        _.each items, (item) ->
          if item.id is $scope.service.id
            $scope.service = item


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

    store.serviceId = item.id
    $localStorage.setObject('bb', store)

    if $scope.routed
      return true

    if $scope.$parent.$has_page_control
      $scope.service = item
      return false
    else if item.is_event_group
      $scope.booking_item.setEventGroup(item)
      $scope.skipThisStep() if options.skip_step
      $scope.decideNextPage(route)
      $scope.routed = true
    else
      $scope.booking_item.setService(item)
      # -----------------------------------------------------------
      $scope.bb.selected_service = $scope.booking_item.service
      # -----------------------------------------------------------
      $scope.skipThisStep() if options.skip_step
      $scope.decideNextPage(route)
      $scope.routed = true
      return true

  $scope.$watch 'service', (newval, oldval) =>
    if $scope.service && $scope.booking_item
      if !$scope.booking_item.service or $scope.booking_item.service.self isnt $scope.service.self
        # only set and broadcast if it's changed
        $scope.booking_item.setService($scope.service)
        $scope.broadcastItemUpdate()
        $scope.bb.selected_service = $scope.service

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbServices
  * @description
  * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
  ###
  $scope.setReady = () =>
    if $scope.service
      $scope.booking_item.setService($scope.service)
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
            $scope.show_custom_array = true
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
    return (!$scope.filters.category_name or service.category_id is $scope.filters.category_name.id) and
      (!$scope.filters.service_name or $scope.service_name_include($scope.filters.service_name)) and
      (!$scope.filters.custom_array_value or $scope.custom_array($scope.filters.custom_array_value)) and
      (!service.price or (service.price >= $scope.filters.price.min * 100 and service.price <= $scope.filters.price.max * 100 ))

  ###**
  * @ngdoc method
  * @name resetFilters
  * @methodOf BB.Directives:bbServices
  * @description
  * Clear the filters
  ###
  $scope.resetFilters = () ->
    if $scope.options.clear_results
      $scope.show_custom_array = false
    $scope.filters.category_name = null
    $scope.filters.service_name = null
    $scope.filters.price.min = 0
    $scope.filters.price.max = 100
    $scope.filters.custom_array_value = null
    $scope.filterChanged()

  ###**
  * @ngdoc method
  * @name filterChanged
  * @methodOf BB.Directives:bbServices
  * @description
  * Filter changed
  ###
  $scope.filterChanged = () ->
    $scope.filtered_items = $filter('filter')($scope.items, $scope.filterFunction)

  return

angular.module('BB.Controllers').controller 'BBServicesCtrl', BBServicesCtrl
