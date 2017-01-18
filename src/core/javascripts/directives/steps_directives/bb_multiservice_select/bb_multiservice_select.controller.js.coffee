'use strict'


angular.module('BB.Controllers').controller 'MultiServiceSelect', ($scope, $rootScope, $q, $attrs, BBModel, $uibModal, $document, AlertService, FormDataStoreService, LoadingService, GeneralOptions) ->

  FormDataStoreService.init 'MultiServiceSelect', $scope, [
    'selectedCategoryName'
  ]

  vm = @

  init = () ->
    vm.loader = LoadingService.$loader($scope)
    vm.company = $scope.bb.company
    vm.stackedItems = $scope.bb.stacked_items
    vm.itemDefaults = $scope.bb.item_defaults


    # wait for services before we begin initialisation
    $scope.$watch 'items', (newval, oldval) ->
      if newval and angular.isArray(newval)
        vm.items = newval 
        readyCategories()

    return 



  ###*
  * @ngdoc method
  * @name readyCategories
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Get categories from company
  ###

  readyCategories = () ->
    promises = []

    BBModel.Category.$query(vm.company).then (categories) ->
      if !categories?
        setServices()
      else 
        matchServicesToCategories(categories)

      if vm.stackedItems and vm.stackedItems.length > 0
        # moving back from calendar
        getStackedItems()
      else
        checkItemDefaults()

      $scope.$broadcast "multi_service_select:loaded"

      vm.loader.setLoaded()

    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

    return 



  setServices = () ->
    vm.services = vm.items

  ###*
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
    allCategoryServices = _.groupBy vm.items, (item) -> 
      item.category_id if item.category_id?

    # match category_index of the services to the category objects
    for categoryIndex of allCategories 
      if allCategoryServices[categoryIndex]
        allCategories[categoryIndex].services = allCategoryServices[categoryIndex]

    allCategoriesArray = _.values(allCategories)

    # if we only have 1 category and some services left over, create a category from the leftover services
    if categories.length is 1
      allCategoriesArray.push createCategory(allCategoriesArray, categories[0])
      vm.changeCategory(categories[0])

    vm.categories = allCategoriesArray 

    return 


  ###*
  * @ngdoc method
  * @name createCategory
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Create category for uncategorised services
  ###
 
  createCategory = (allCategoriesArray, category) ->
    newCategory = new BBModel.Category()
    newCategory.name = 'Other Services' 
    newCategory.services = _.difference(vm.items, category.services)
    return newCategory


  ###*
  * @ngdoc method
  * @name checkItemDefaults
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Get stacked items from $scope.bb.stacked_items
  ###

  getStackedItems = () ->
    for stackedItem in vm.stackedItems
      for item in vm.items
        if item.self is stackedItem.service.self
          stackedItem.service = item
          stackedItem.service.selected = true
          break
    return 

  ###*
  * @ngdoc method
  * @name checkItemDefaults
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Check item defaults
  ###

  checkItemDefaults = () ->
    return if !vm.itemDefaults.service
    for service in $vm.items
      if service.self is vm.itemDefaults.service.self
        vm.addItem(service)
        return


  selectCategory = (categoryDetails) ->
    # check it a category is already selected
    if vm.selectedCategoryName and vm.selectedCategoryName is categoryDetails.name
      vm.selectedCategory = vm.categories[vm.categories.length - 1]
    # or if there's a default category
    else if vm.itemDefaults.category and vm.itemDefaults.category.name is categoryDetails.name and !vm.selectedCategory
      vm.selectedCategory = vm.categories[vm.categories.length - 1]
      vm.selectedCategoryName = vm.selectedCategory.name

    return


  ###*
  * @ngdoc method
  * @name changeCategory
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Change category in according of category name and services parameres
  *
  * @param {string} category_name The category name
  * @param {array} services The services array
  ###
  vm.changeCategory = (category) ->
    categoryName = category.name if category.name?
    services = category.services if category.services?

    if categoryName and services 
      vm.selectedCategory = {
        name: categoryName
        services: services 
      }

      vm.selectedCategoryName = vm.selectedCategory.name

    return


  ###*
  * @ngdoc method
  * @name addItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add item in according of item and duration parameters
  *
  * @param {array} item The item that been added
  * @param {date} duration The duration
  ### 
  vm.addItem = (item, duration) ->
    if vm.stackedItems.length < GeneralOptions.maxServices
      $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
      item.selected = true
      iitem = new BBModel.BasketItem(null, $scope.bb)
      iitem.setDefaults(vm.itemDefaults)
      iitem.setService(item)
      iitem.setPrice(item.price) if item.prices.length > 0
      iitem.setDuration(duration) if duration
      iitem.setGroup(item.group)
      $scope.bb.stackItem(iitem)
      $rootScope.$broadcast "multi_service_select:itemAdded"
      AlertService.info({msg: "#{item.name} added to your service selection", persist:false}) if GeneralOptions.raiseAlerts
    else
      AlertService.add("warning", { msg: "You have already selected the maximum number of services" })

    return 
      

  ###*
  * @ngdoc method
  * @name removeItem
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Remove item in according of item and options parameters
  *
  * @params {array} item The item that been removed
  * @params {array} options The options remove
  ###
  vm.removeItem = (item, options) ->
    item.selected = false

    $scope.bb.deleteStackedItemByService(item)

    $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
    $rootScope.$broadcast "multi_service_select:itemRemoved"
    for i in vm.items
      if i.self is item.self
        i.selected = false
        break

    return 


  ###*
  * @ngdoc method
  * @name addService
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Add service which add a new item
  ###
  vm.addService = () ->
    $rootScope.$broadcast "multi_service_select:addItem"
    return


  ###*
  * @ngdoc method
  * @name selectDuration
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Select duration in according of service parameter and display the modal
  *
  * @params {object} service The service
  * @params {integer} duration The chosen service duration 
  ###
  vm.selectDuration = (service, duration) ->
    service.price = service.getPriceByDuration(duration)
    service.duration = duration
    service.listed_duration = duration

    return 


  init()