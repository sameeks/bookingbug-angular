'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbMultiServiceSelect
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of multi service selected for the currently in scope company
*
* <pre>
* restrict: 'AE'
* scope: true
* </pre>
*
* @param {hash}  bbMultiServiceSelect A hash of options
* @property {object} options The options of service
* @property {object} max_services The max services
* @property {boolean} ordered_categories Verify if categories are ordered or not
* @property {array} services The services
* @property {array} company The company
* @property {array} items An array of items service
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbMultiServiceSelect', () ->
  restrict: 'AE'
  scope : true
  controller : 'MultiServiceSelect'

angular.module('BB.Controllers').controller 'MultiServiceSelect', ($scope, $rootScope,
  $q, $attrs, BBModel, $uibModal, $document, AlertService, FormDataStoreService, LoadingService) ->

  FormDataStoreService.init 'MultiServiceSelect', $scope, [
    'selectedCategoryName'
  ]

  $scope.options                    = $scope.$eval($attrs.bbMultiServiceSelect) or {}
  $scope.options.useCategories      = $scope.options.useCategories or false
  $scope.options.useSubCategories   = $scope.options.useSubCategories or false  
  $scope.options.orderedCategories  = $scope.options.orderedCategories or false
  $scope.options.maxServices        = $scope.options.maxServices   or Infinity
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
        if $scope.options.useCategories then readyCategories() else readyServices()


  readyServices = () ->
    $scope.services = $scope.items

    if $scope.bb.stacked_items and $scope.bb.stacked_items.length > 0
      getStackedItems()
    else
      checkItemDefaults()


  readyCategories = () ->
    promises = []

    promises.push(BBModel.Category.$query($scope.bb.company))

    # company question promise
    promises.push($scope.company.$getCompanyQuestions()) if $scope.company.$has('company_questions')

    $q.all(promises).then (result) ->

      $scope.companyQuestions = result[1]

      initialiseCategories(result[0]) 

      if $scope.bb.stacked_items and $scope.bb.stacked_items.length > 0
        getStackedItems()
      else
        checkItemDefaults()

      if $scope.bb.moving_booking
        $scope.nextStep()


      $scope.$broadcast "multi_service_select:loaded"

      loader.setLoaded()

    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


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
    if $scope.options.orderedCategories
      for category in categories
          category.order = parseInt(category.name.slice(0,2))
          category.name  = category.name.slice(3)

    # index categories by their id
    $scope.allCategories = _.indexBy(categories, 'id')

    # group services by category id
    allCategories = _.groupBy($scope.items, (item) -> item.category_id)

    # find any sub categories
    if $scope.options.useSubCategories
      subCategories = findSubCategories()

    categories = filterEmptyCategories(allCategories)


    # build the catagories array
    $scope.categories = []

    for category_id, services of categories
      category = {}
      
      if subCategories
        groupSubCategories(category, subCategories, services)
      else
        category.services = services

      setCategoryDetails(category, category_id)


  findSubCategories = () ->
    subCategories = _.findWhere($scope.companyQuestions, {name: 'Extra Category'})
    subCategories = _.map(subCategories.question_items, (subCategory) -> subCategory.name) if subCategories

    return subCategories


  filterEmptyCategories = (allCategories) ->
    # filter categories that have no services
    categories = {}
    for own key, value of allCategories
      categories[key] = value if value.length > 0
    return categories


  groupSubCategories = (category, subCategories, services) ->
    groupedSubCategories = []
    for subCategory in subCategories
      groupedSubCategory = {
        name: subCategory,
        services: _.filter(services, (service) -> service.extra.extra_category is subCategory)
      }

      # only add the sub category if it has some services
      groupedSubCategories.push(groupedSubCategory) if groupedSubCategory.services.length > 0
    category.subCategories = groupedSubCategories


  setCategoryDetails = (category, category_id) ->
    # get the name and description
    categoryDetails = {name: $scope.allCategories[category_id].name, description: $scope.allCategories[category_id].description} if $scope.allCategories[category_id]
    # set the category
    category.name = categoryDetails.name
    category.description = categoryDetails.description

    # get the order if instruccted
    category.order = $scope.allCategories[category_id].order if $scope.options.orderedCategories && $scope.allCategories[category_id]

    $scope.categories.push(category)

    selectCategory(categoryDetails)


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
  $scope.changeCategory = (categoryName, services) ->

    if categoryName and services
      $scope.selectedCategory = {
        name: categoryName
        subCategories: services
      }
      $scope.selectedCategoryName = $scope.selectedCategory.name
      $rootScope.$broadcast "multi_service_select:categoryChanged"

  ###**
  * @ngdoc method
  * @name changeCategoryName
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Change the category name
  ###
  $scope.changeCategoryName = () ->
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
    if $scope.bb.stacked_items.length < $scope.options.maxServices
      $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
      item.selected = true
      iitem = new BBModel.BasketItem(null, $scope.bb)
      iitem.setDefaults($scope.bb.item_defaults)
      iitem.setService(item)
      iitem.setDuration(duration) if duration
      iitem.setGroup(item.group)
      $scope.bb.stackItem(iitem)
      $rootScope.$broadcast "multi_service_select:itemAdded"
      AlertService.info({msg: "#{item.name} added to your service selection", persist:false}) if $scope.options.raiseAlerts
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

    if options and options.type is 'BasketItem'
      $scope.bb.deleteStackedItem(item)
    else
      $scope.bb.deleteStackedItemByService(item)

    $scope.bb.clearStackedItemsDateTime() # clear any selected date/time as the selection has changed
    $rootScope.$broadcast "multi_service_select:itemRemoved"
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
    else if $scope.bb.stacked_items.length is 1
      # first clear anything already in the basket and then set the basket item
      $scope.quickEmptybasket({preserve_stacked_items: true}) if $scope.bb.basket && $scope.bb.basket.items.length > 0
      $scope.setBasketItem($scope.bb.stacked_items[0])
      $scope.decideNextPage()
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select at least one service to continue" })

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
  * @name setReady
  * @methodOf BB.Directives:bbMultiServiceSelect
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = () ->
    if $scope.bb.stacked_items.length > 1
      return true
    else if $scope.bb.stacked_items.length is 1
      # first clear anything already in the basket and then set the basket item
      $scope.quickEmptybasket({preserve_stacked_items: true}) if $scope.bb.basket && $scope.bb.basket.items.length > 0
      $scope.setBasketItem($scope.bb.stacked_items[0])
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select at least one service to continue" })
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

