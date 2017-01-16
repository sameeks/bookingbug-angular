'use strict'


angular.module('BB.Controllers').controller 'MultiServiceSelect', ($scope, $rootScope, $q, $attrs, BBModel, $uibModal, $document, AlertService, FormDataStoreService, LoadingService, GeneralOptions) ->

  FormDataStoreService.init 'MultiServiceSelect', $scope, [
    'selectedCategoryName'
  ]

  loader = LoadingService.$loader($scope)

  $rootScope.connection_started.then ->
    if $scope.bb.company.$has('parent') && !$scope.bb.company.$has('company_questions')
      $scope.bb.company.$getParent().then (parent) ->
        $scope.company = parent
    else
      $scope.company = $scope.bb.company


    # wait for services before we begin initialisation
    $scope.$watch 'items', (newval, oldval) ->
      if newval and angular.isArray(newval)
        $scope.items = newval 
        readyCategories()



  ###**
  * @ngdoc method
  * @name readyCategories
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Get categories from company
  ###

  readyCategories = () ->
    promises = []

    BBModel.Category.$query($scope.bb.company).then (categories) ->
      if !categories?
        setServices()
      else 
        matchServicesToCategories(categories)

      if $scope.bb.stacked_items and $scope.bb.stacked_items.length > 0
        # moving back from calendar
        getStackedItems()
      else
        checkItemDefaults()

      $scope.$broadcast "multi_service_select:loaded"

      loader.setLoaded()

    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')



  setServices = () ->
    $scope.services = $scope.items

  ###**
  * @ngdoc method
  * @name matchServicesToCategories
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Match services to categories by id
  *
  * @param {array} categories The categories of service
  ###

  matchServicesToCategories = (categories) ->

    # index categories by their id 
    allCategories = _.indexBy(categories, 'id')

    # group services by their category_id
    allCategoryServices = _.groupBy $scope.items, (item) -> 
      item.category_id if item.category_id?

    # match category_index of the services to the category objects
    for categoryIndex of allCategories 
      if allCategoryServices[categoryIndex]
        allCategories[categoryIndex].services = allCategoryServices[categoryIndex]

    $scope.categories = _.values(allCategories)


  ###**
  * @ngdoc method
  * @name checkItemDefaults
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Get stacked items from $scope.bb.stacked_items
  ###

  getStackedItems = () ->
    for stacked_item in $scope.bb.stacked_items
      for item in $scope.items
        if item.self is stacked_item.service.self
          stacked_item.service = item
          stacked_item.service.selected = true
          break

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


  selectCategory = (categoryDetails) ->
    # check it a category is already selected
    if $scope.selectedCategoryName and $scope.selectedCategoryName is categoryDetails.name
      $scope.selectedCategory = $scope.categories[$scope.categories.length - 1]
    # or if there's a default category
    else if $scope.bb.item_defaults.category and $scope.bb.item_defaults.category.name is categoryDetails.name and !$scope.selectedCategory
      $scope.selectedCategory = $scope.categories[$scope.categories.length - 1]
      $scope.selectedCategoryName = $scope.selectedCategory.name


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
  $scope.changeCategory = (category) ->
    categoryName = category.name if category.name?
    services = category.services if category.services?

    if categoryName and services 
      $scope.selectedCategory = {
        name: categoryName
        services: services 
      }

      $scope.selectedCategoryName = $scope.selectedCategory.name
      $rootScope.$broadcast "multi_service_select:categoryChanged"


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
    if $scope.bb.stacked_items.length < GeneralOptions.maxServices
      $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
      item.selected = true
      iitem = new BBModel.BasketItem(null, $scope.bb)
      iitem.setDefaults($scope.bb.item_defaults)
      iitem.setService(item)
      iitem.setPrice(item.price) if item.prices.length > 0
      iitem.setDuration(duration) if duration
      iitem.setGroup(item.group)
      $scope.bb.stackItem(iitem)
      $rootScope.$broadcast "multi_service_select:itemAdded"
      AlertService.info({msg: "#{item.name} added to your service selection", persist:false}) if GeneralOptions.raiseAlerts
    else
      AlertService.add("warning", { msg: "You have already selected the maximum number of services" })
      

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

    $scope.bb.deleteStackedItemByService(item)

    $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
    $rootScope.$broadcast "multi_service_select:itemRemoved"
    for i in $scope.items
      if i.self is item.self
        i.selected = false
        break


  ###**
  * @ngdoc method
  * @name addService
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add service which add a new item
  ###
  $scope.addService = () ->
    $rootScope.$broadcast "multi_service_select:addItem"


  ###**
  * @ngdoc method
  * @name selectDuration
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Select duration in according of service parameter and display the modal
  *
  * @params {object} service The service
  * @params {integer} duration The chosen service duration 
  ###
  $scope.selectDuration = (service, duration) ->
    service.price = service.getPriceByDuration(duration)
    service.duration = duration
    service.listed_duration = duration

