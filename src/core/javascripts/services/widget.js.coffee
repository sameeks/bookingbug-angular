'use strict';

###**
* @ngdoc service
* @name BB.Models:BBWidget
*
* @description
* Representation of an BBWidget Object
* .<br/> Widget class contains handy functions and variables used in building and displaying a booking widget.
*
* @property {number} uid Widget unique id
* @property {string} page_suffix Widget page suffix
* @property {array} steps Wdget steps
* @property {array} allSteps Widget all steps
* @property {object} item_defaults Widget item defaults
* @property {boolean} Checks if it's using the basket or not
* @property {boolean} confirmCheckout Confirms the checkout
* @property {boolean} isAdm Checks if a user is amin
* @property {string} payment_status Payment status
####

angular.module('BB.Models').factory "BBWidget",
($q, $urlMatcherFactory, $location,  $window, $rootScope, BreadcrumbService, BBModel) ->

  class Widget

    constructor: () ->
      # uid used to store form data for user journeys
      @uid = _.uniqueId 'bbwidget_'
      @page_suffix = ""
      @steps = []
      @allSteps = []
      @item_defaults = {}
      @usingBasket = false  # bu defalt we're not going to use a basket
      @confirmCheckout = false
      @isAdmin = false
      @payment_status = null

    ###**
    * @ngdoc method
    * @name pageURL
    * @methodOf BB.Models:BBWidget
    * @description
    * Gets the page url using the route parameter.
    *
    * @param {string} route Page route
    *
    * @returns {string} Page url
    ###
    pageURL: (route) ->
      route + '.html'

    ###**
    * @ngdoc method
    * @name updateRoute
    * @methodOf BB.Models:BBWidget
    * @description
    * Updates the page route.
    *
    * @param {string} page page parameter
    *
    * @returns {string} url
    ###
    updateRoute: (page) ->
      return if !@routeFormat

      page ||= @current_page
      pattern = $urlMatcherFactory.compile(@routeFormat)
      service_name = "-"
      event_group = "-"
      if @current_item
        service_name = @convertToDashSnakeCase(@current_item.service.name) if @current_item.service
        event_group = @convertToDashSnakeCase(@current_item.event_group.name) if @current_item.event_group
        date = @current_item.date.date.toISODate() if @current_item.date
        time = @current_item.time.time if @current_item.time
        company = @convertToDashSnakeCase(@current_item.company.name) if @current_item.company
      prms = angular.copy(@route_values) if @route_values
      prms ||= {}
      angular.extend(prms,{page: page, company: company, service: service_name, event_group: event_group, date: date, time: time})
      url = pattern.format(prms)
      url = url.replace(/\/+$/, "")
      $location.path(url)
      @routing = true
      return url

    ###**
    * @ngdoc method
    * @name setRouteFormat
    * @methodOf BB.Models:BBWidget
    * @description
    * Sets the route format.
    *
    * @param {string} route Page route
    ###
    setRouteFormat: (route) ->
      @routeFormat = route
      return if !@routeFormat

      @routing = true

      path = $location.path()

      if path
        parts = @routeFormat.split("/")
        while parts.length > 0 && !match
          match_test = parts.join("/")
          pattern = $urlMatcherFactory.compile(match_test)
          match = pattern.exec(path)
          parts.pop()

        if match
          @item_defaults.company = decodeURIComponent(match.company) if match.company
          @item_defaults.service = decodeURIComponent(match.service) if match.service && match.service != "-"
          @item_defaults.event_group = match.event_group if match.event_group && match.event_group != "-"
          @item_defaults.person = decodeURIComponent(match.person) if match.person
          @item_defaults.resource = decodeURIComponent(match.resource) if match.resource
          @item_defaults.resources = decodeURIComponent(match.resoures) if match.resources
          @item_defaults.date = match.date if match.date
          @item_defaults.time = match.time if match.time
          @route_matches = match

    ###**
    * @ngdoc method
    * @name matchURLToStep
    * @methodOf BB.Models:BBWidget
    * @description
    * Match url to step.
    *
    * @returns {number} Will return the step number if the step url exists and matches the path.
    ###

    matchURLToStep: () ->
      return null if !@routeFormat
      path = $location.path()
      step = _.findWhere(@allSteps, {page: path.replace(/\//g, '')})
      if step
        return step.number
      else
        return null

    ###**
    * @ngdoc method
    * @name convertToDashSnakeCase
    * @methodOf BB.Models:BBWidget
    * @description
    * Converts a string to dash snake case.
    *
    * @param {string} str str parameter
    *
    * @returns {string} converted string
    ###
    convertToDashSnakeCase: (str) ->
        str = str.toLowerCase();
        str = $.trim(str)
        # replace all punctuation and special chars
        str = str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '')
        # replace any double or more spaces
        str = str.replace(/\s{2,}/g, ' ')
        # convert to sanke case
        str = str.replace(/\s/g, '-')
        return str

    ###**
    * @ngdoc method
    * @name recordCurrentPage
    * @methodOf BB.Models:BBWidget
    * @description
    * Records the current page and determines the current step from either the predefined steps or the steps that have been passed already.
    *
    * @returns {string} The returned record step
    ###
    recordCurrentPage: () =>
      if !@current_step
        @current_step = 0
      match = false
      # can we find a match for this step against either previous or existing steps?
      # first check the pre-defined steps
      if @allSteps
        for step in @allSteps
          if step.page == @current_page
            @current_step = step.number
            match = true
      # now check the previously visited steps
      if !match
        for step in @steps
          if step && step.page == @current_page
            @current_step = step.number
            match = true
      # if still not found - assume it's a new 'next' page and add 1 to the step count
      if !match
        @current_step += 1

      title = ""
      if @allSteps
        for step in @allSteps
          step.active = false
          step.passed = step.number < @current_step
        if @allSteps[@current_step-1]
          @allSteps[@current_step-1].active = true
          title = @allSteps[@current_step-1].title
      @recordStep(@current_step, title)

    ###**
    * @ngdoc method
    * @name recordStep
    * @methodOf BB.Models:BBWidget
    * @description
    * Records the step using the step and title parameters.
    *
    * @param {number} step step number
    * @param {string} title title parameter
    *
    * @returns {boolean} If is the last step or not
    ###
    recordStep: (step, title) =>
      @steps[step-1] = {
        url: @updateRoute(@current_page),
        current_item: @current_item.getStep(),
        page: @current_page,
        number: step,
        title: title,
        stacked_length: @stacked_items.length
      }

      BreadcrumbService.setCurrentStep(step)

      for step in @steps
        if step
          step.passed = step.number < @current_step
          step.active = step.number == @current_step

      # calc percentile complete
      @calculatePercentageComplete(step.number)

      # check if we're at the last step
      if (@allSteps && @allSteps.length == step ) || @current_page == 'checkout'
        @last_step_reached = true
      else
        @last_step_reached = false

    ###**
    * @ngdoc method
    * @name calculatePercentageComplete
    * @methodOf BB.Models:BBWidget
    * @description
    * If the step_number and allSteps are not empty this function  will return their ratio in percentage.
    *
    * @param {number} step_number Step number
    *
    * @returns {number} The returned percentage complete
    ###
    calculatePercentageComplete: (step_number) =>
      @percentage_complete = if step_number && @allSteps then step_number / @allSteps.length * 100 else 0

    ###**
    * @ngdoc method
    * @name setRoute
    * @methodOf BB.Models:BBWidget
    * @description
    * Sets the route data.
    *
    * @param {array} rdata radata array
    *
    * @returns {object} The returned route set
    ###
    # setup full route data
    setRoute: (rdata) =>
      @allSteps.length = 0
      @nextSteps = {}
      @firstStep = rdata[0].page unless rdata is undefined || rdata is null || rdata[0] is undefined
      for step, i in rdata
        @disableGoingBackAtStep = i+1 if step.disable_breadcrumbs
        if rdata[i+1]
          @nextSteps[step.page] = rdata[i+1].page
        @allSteps.push({number: i+1, title: step.title, page: step.page})
        if step.when
          @routeSteps ||= {}
          for route in step.when
            @routeSteps[route] = step.page
      if @$wait_for_routing
        @$wait_for_routing.resolve()

    ###**
    * @ngdoc method
    * @name setBasicRoute
    * @methodOf BB.Models:BBWidget
    * @description
    * Sets the basic route using routes parameter.
    *
    * @param {array} routes routes array
    *
    * @returns {object} The returned route set
    ###
    setBasicRoute: (routes) =>
      @nextSteps = {}
      @firstStep = routes[0]
      for step, i in routes
        @nextSteps[step] = routes[i+1]
      if @$wait_for_routing
        @$wait_for_routing.resolve()

    ###**
    * @ngdoc method
    * @name waitForRoutes
    * @methodOf BB.Models:BBWidget
    * @description
    * Wait for route
    *
    * @returns {promise} A promise
    ###
    waitForRoutes: () =>
      if !@$wait_for_routing
        @$wait_for_routing = $q.defer()


    ###############################################################
    # stacking items

    ###**
    * @ngdoc method
    * @name stackItem
    * @methodOf BB.Models:BBWidget
    * @description
    * Pushes an item in stacked_items array.
    *
    * @param {object} item item object
    *
    * @returns {promise} A promise that on success will sort the stacked items
    ###
    stackItem: (item) =>
      @stacked_items.push(item)
      @sortStackedItems()

    ###**
    * @ngdoc method
    * @name setStackedItems
    * @methodOf BB.Models:BBWidget
    * @description
    * Sets the stacket items using items parameter.
    *
    * @param {array} items items array
    *
    * @returns {promise} A promise that on success will sort the stacked items
    ###
    setStackedItems: (items) =>
      @stacked_items = items
      @sortStackedItems()

    ###**
    * @ngdoc method
    * @name sortStackedItems
    * @methodOf BB.Models:BBWidget
    * @description
    * Sorts the  stacked items.
    *
    * @returns {array} The returned sorted stacked items
    ###
    sortStackedItems: =>
      # make sure all of the cats resolved
      arr = []
      for item in @stacked_items
        arr = arr.concat(item.promises)

      $q.all(arr)['finally'] () =>
        @stacked_items = @stacked_items.sort (a, b) =>
          if a.time && b.time
            a.time.time > b.time.time ? 1 : -1
          else if a.service.category && !b.service.category
            1
          else if b.service.category && !a.service.category
            -1
          else if !b.service.category && !a.service.category
            1
          else
            a.service.category.order > b.service.category.order ? 1 : -1

    ###**
    * @ngdoc method
    * @name deleteStackedItem
    * @methodOf BB.Models:BBWidget
    * @description
    * Deletes an stacked item.
    *
    * @param {object} item Item to be deleted
    *
    * @returns {array} The returned stacked items
    ###
    deleteStackedItem: (item) =>
      if item && item.id
        BBModel.Basket.$deleteItem(item, @company, {bb: @})

      @stacked_items = @stacked_items.filter (i) -> i isnt item

    ###**
    * @ngdoc method
    * @name removeItemFromStack
    * @methodOf BB.Models:BBWidget
    * @description
    * Removes an item from stack.
    *
    * @param {object} item Item to be removed
    *
    * @returns {array} The returned stacked items
    ###
    removeItemFromStack: (item) =>
      @stacked_items = @stacked_items.filter (i) -> i isnt item

    ###**
    * @ngdoc method
    * @name deleteStackedItemByService
    * @methodOf BB.Models:BBWidget
    * @description
    * Deletes the  stacked item by service.
    *
    * @param {object} item Item to be deleted
    *
    * @returns {array} The returned stacked items
    ###
    deleteStackedItemByService: (item) =>
      for i in @stacked_items
        if i && i.service && i.service.self == item.self && i.id
          BBModel.Basket.$deleteItem(i, @company, {bb: @})
      @stacked_items = @stacked_items.filter (i) -> (i && i.service && i.service.self isnt item.self)

    ###**
    * @ngdoc method
    * @name emptyStackedItems
    * @methodOf BB.Models:BBWidget
    * @description
    * Empties the stacked items.
    *
    * @returns {array} Empty stacked items array
    ###
    emptyStackedItems: () =>
      @stacked_items = []

    ###**
    * @ngdoc method
    * @name pushStackToBasket
    * @methodOf BB.Models:BBWidget
    * @description
    * Pushes the stack to basket and will delete all the items from it after that.
    *
    ###
    pushStackToBasket: () ->
      @basket ||= new new BBModel.Basket(null, @)
      for i in @stacked_items
        @basket.addItem(i)
      @emptyStackedItems()

    ###**
    * @ngdoc method
    * @name totalStackedItemsDuration
    * @methodOf BB.Models:BBWidget
    * @description
    * Gets the total stacked items duration.
    *
    * @returns {number} Duration
    ###
    totalStackedItemsDuration: ->
      duration = 0
      for item in @stacked_items
        duration += item.service.listed_duration if item.service and item.service.listed_duration
      return duration

    ###**
    * @ngdoc method
    * @name clearStackedItemsDateTime
    * @methodOf BB.Models:BBWidget
    * @description
    * Clears the  stacked items date and time.
    *
    * @returns {array} The returned items with date and time cleared
    ###
    clearStackedItemsDateTime: ->
      for item in @stacked_items
        item.clearDateTime()

    ###**
    * @ngdoc method
    * @name clearAddress
    * @methodOf BB.Models:BBWidget
    * @description
    * Clears the address.
    ###
    # Address methods
    clearAddress: () =>
      delete @address1
      delete @address2
      delete @address3
      delete @address4
      delete @address5
