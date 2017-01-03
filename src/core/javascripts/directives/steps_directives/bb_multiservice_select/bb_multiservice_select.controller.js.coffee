'use strict'

angular.module('BB.Controllers').controller 'MultiServiceSelect', ($scope, $rootScope,
  $q, $attrs, BBModel, $uibModal, $document, AlertService, FormDataStoreService, LoadingService) ->

  FormDataStoreService.init 'MultiServiceSelect', $scope, [
    'selected_category_name'
  ]

  $scope.options                    = $scope.$eval($attrs.bbMultiServiceSelect) or {}
  $scope.options.max_services       = $scope.options.max_services or Infinity
  $scope.options.ordered_categories = $scope.options.ordered_categories or false
  $scope.options.services           = $scope.options.services or 'items'

  loader = LoadingService.$loader($scope)

  $rootScope.connection_started.then ->
    if $scope.bb.company.$has('parent') && !$scope.bb.company.$has('company_questions')
      $scope.bb.company.$getParent().then (parent) ->
        $scope.company = parent
        initialise()
    else
      $scope.company = $scope.bb.company

    # wait for services before we begin initialisation
    $scope.$watch $scope.options.services, (newval, oldval) ->
      if newval and angular.isArray(newval)
        $scope.items = newval
        initialise()

  initialise = () ->

    return if !$scope.items or !$scope.company

    $scope.initialised = true

    promises = []

    promises.push(BBModel.Category.$query($scope.bb.company))

    # company question promise
    promises.push($scope.company.$getCompanyQuestions()) if $scope.company.$has('company_questions')

    $q.all(promises).then (result) ->

      $scope.company_questions = result[1]

      initialiseCategories(result[0])

      # if there's already some stacked items (i.e. we've come back to this page,
      # make sure they're selected)
      if $scope.bb.stacked_items and $scope.bb.stacked_items.length > 0
        for stacked_item in $scope.bb.stacked_items
          for item in $scope.items
            if item.self is stacked_item.service.self
              stacked_item.service = item
              stacked_item.service.selected = true
              break
      else
        # check item defaults
        checkItemDefaults()

      # if we're moving the booking, just move to the next step
      if $scope.bb.moving_booking
        $scope.nextStep()


      $scope.$broadcast "multi_service_select:loaded"

      loader.setLoaded()

    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name checkItemDefaults
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Check item defaults
  ###
  checkItemDefaults = () ->
    return if !$scope.bb.item_defaults.service
    for service in $scope.items
      if service.self is $scope.bb.item_defaults.service.self
        $scope.addItem(service)
        return

  ###**
  * @ngdoc method
  * @name initialiseCategories
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Initialize the categories in according of categories parameter
  *
  * @param {array} categories The categories of service
  ###
  initialiseCategories = (categories) ->

    # extract order from category name if we're using ordered categories
    if $scope.options.ordered_categories
      for category in categories
          category.order = parseInt(category.name.slice(0,2))
          category.name  = category.name.slice(3)

    # index categories by their id
    $scope.all_categories = _.indexBy(categories, 'id')

    # group services by category id
    all_categories = _.groupBy($scope.items, (item) -> item.category_id)

    # find any sub categories
    sub_categories = _.findWhere($scope.company_questions, {name: 'Extra Category'})
    sub_categories = _.map(sub_categories.question_items, (sub_category) -> sub_category.name) if sub_categories

    # filter categories that have no services
    categories = {}
    for own key, value of all_categories
      categories[key] = value if value.length > 0

    # build the catagories array
    $scope.categories = []

    for category_id, services of categories

      category = {}

      # group services by their subcategory
      grouped_sub_categories = []
      if sub_categories
        for sub_category in sub_categories
          grouped_sub_category = {
            name: sub_category,
            services: _.filter(services, (service) -> service.extra.extra_category is sub_category)
          }

          # only add the sub category if it has some services
          grouped_sub_categories.push(grouped_sub_category) if grouped_sub_category.services.length > 0
        category.sub_categories = grouped_sub_categories
      else
        category.services = services

      # get the name and description
      category_details = {name: $scope.all_categories[category_id].name, description: $scope.all_categories[category_id].description} if $scope.all_categories[category_id]

      # set the category
      category.name = category_details.name
      category.description = category_details.description

      # get the order if instruccted
      category.order = $scope.all_categories[category_id].order if $scope.options.ordered_categories && $scope.all_categories[category_id]

      $scope.categories.push(category)

      # check it a category is already selected
      if $scope.selected_category_name and $scope.selected_category_name is category_details.name
        $scope.selected_category = $scope.categories[$scope.categories.length - 1]
      # or if there's a default category
      else if $scope.bb.item_defaults.category and $scope.bb.item_defaults.category.name is category_details.name and !$scope.selected_category
        $scope.selected_category = $scope.categories[$scope.categories.length - 1]
        $scope.selected_category_name = $scope.selected_category.name

  ###**
  * @ngdoc method
  * @name changeCategory
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Change category in according of category name and services parameres
  *
  * @param {string} category_name The category name
  * @param {array} services The services array
  ###
  $scope.changeCategory = (category_name, services) ->

    if category_name and services
      $scope.selected_category = {
        name: category_name
        sub_categories: services
      }
      $scope.selected_category_name = $scope.selected_category.name
      $rootScope.$broadcast "multi_service_select:category_changed"

  ###**
  * @ngdoc method
  * @name changeCategoryName
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Change the category name
  ###
  $scope.changeCategoryName = () ->
      $scope.selected_category_name = $scope.selected_category.name
      $rootScope.$broadcast "multi_service_select:category_changed"

  ###**
  * @ngdoc method
  * @name addItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add item in according of item and duration parameters
  *
  * @param {array} item The item that been added
  * @param {date} duration The duration
  ###
  $scope.addItem = (item, duration) ->
    if $scope.bb.stacked_items.length < $scope.options.max_services
      $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
      item.selected = true
      iitem = new BBModel.BasketItem(null, $scope.bb)
      iitem.setDefaults($scope.bb.item_defaults)
      iitem.setService(item)
      iitem.setDuration(duration) if duration
      iitem.setGroup(item.group)
      $scope.bb.stackItem(iitem)
      $rootScope.$broadcast "multi_service_select:item_added"
      AlertService.info({msg: "#{item.name} added to your treatment selection", persist:false}) if $scope.options.raise_alerts
    else
      for i in $scope.items
        i.popover = "Sorry, you can only book a maximum of #{$scope.options.max_services} treatments"
        i.popoverText = i.popover

  ###**
  * @ngdoc method
  * @name removeItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Remove item in according of item and options parameters
  *
  * @params {array} item The item that been removed
  * @params {array} options The options remove
  ###
  $scope.removeItem = (item, options) ->
    item.selected = false

    if options and options.type is 'BasketItem'
      $scope.bb.deleteStackedItem(item)
    else
      $scope.bb.deleteStackedItemByService(item)

    $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
    $rootScope.$broadcast "multi_service_select:item_removed"
    for i in $scope.items
      if i.self is item.self
        i.selected = false
        break

  ###**
  * @ngdoc method
  * @name removeStackedItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Removed stacked item whose type is 'BasketItem'
  *
  * @params {array} item The item that been removed
  ###
  $scope.removeStackedItem = (item) ->
    $scope.removeItem(item, {type: 'BasketItem'})

  ###**
  * @ngdoc method
  * @name nextStep
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Next step to selected an basket item, if basket item is not selected she display an error message
  ###
  $scope.nextStep = () ->
    if $scope.bb.stacked_items.length > 1
      $scope.decideNextPage()
    else if $scope.bb.stacked_items.length == 1
      # first clear anything already in the basket and then set the basket item
      $scope.quickEmptybasket({preserve_stacked_items: true}) if $scope.bb.basket && $scope.bb.basket.items.length > 0
      $scope.setBasketItem($scope.bb.stacked_items[0])
      $scope.decideNextPage()
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select at least one treatment to continue" })

  ###**
  * @ngdoc method
  * @name addService
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add service which add a new item
  ###
  $scope.addService = () ->
    $rootScope.$broadcast "multi_service_select:add_item"

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () ->
    if $scope.bb.stacked_items.length > 1
      return true
    else if $scope.bb.stacked_items.length == 1
      # first clear anything already in the basket and then set the basket item
      $scope.quickEmptybasket({preserve_stacked_items: true}) if $scope.bb.basket && $scope.bb.basket.items.length > 0
      $scope.setBasketItem($scope.bb.stacked_items[0])
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select at least one treatment to continue" })
      return false

  ###**
  * @ngdoc method
  * @name selectDuration
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Select duration in according of service parameter and display the modal
  *
  * @params {object} service The service
  ###
  $scope.selectDuration = (service) ->

    if service.durations.length is 1
      $scope.addItem(service)
    else

      modalInstance = $uibModal.open
        templateUrl: $scope.getPartial('_select_duration_modal')
        scope: $scope
        controller: ($scope, $uibModalInstance, service) ->
          $scope.durations = service.durations
          $scope.duration = $scope.durations[0]
          $scope.service = service

          $scope.cancel = ->
            $uibModalInstance.dismiss 'cancel'
          $scope.setDuration = () ->
            $uibModalInstance.close({service: $scope.service, duration: $scope.duration})
        resolve:
          service: ->
            service

      modalInstance.result.then (result) ->
        $scope.addItem(result.service, result.duration)
