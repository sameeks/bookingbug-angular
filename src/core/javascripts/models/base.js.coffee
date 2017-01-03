'use strict'

# build a dynamic injector for each of the models!
# This creates a service that is capable of creating any given model
# It uses dynamic injection, to avoid a cuicular dependancy - as any model, needs to be able to create instances of other models


angular.module('BB.Models').service "BBModel", ($q, $injector) ->


angular.module('BB.Models').run ($q, $injector, BBModel) ->

  # the top level models
  models = ['Address', 'Answer', 'Affiliate', 'Basket', 'BasketItem',
    'BookableItem', 'Category', 'Client', 'ClientDetails', 'Company',
    'CompanySettings', 'Day', 'Event', 'EventChain', 'EventGroup',
    'EventTicket', 'EventSequence', 'ItemDetails', 'PaymentCallbacks', 'Person', 'PurchaseItem',
    'PurchaseTotal', 'Question', 'Resource', 'Service', 'Slot', 'Space',
    'Clinic', 'SurveyQuestion','TimeSlot', 'BusinessQuestion', 'Image', 'Deal',
    'PrePaidBooking', 'MembershipLevel', 'Product', 'BBCollection',
    'ExternalPurchase', 'PackageItem', 'BulkPurchase', 'Pagination', 'Reason',
    'Login']

  for model in models
    BBModel[model] = $injector.get(model + "Model")

  # purchase models
  purchase_models = ['Booking', 'Total', 'CourseBooking']
  pfuncs = {}
  for model in purchase_models
    pfuncs[model] = $injector.get("Purchase." + model + "Model")
  BBModel['Purchase'] = pfuncs





############################
# The Base Model

# this provides some helpful functions to the models, that map various undelrying HAL resource functions

angular.module('BB.Models').service "BaseModel", ($q, $injector, $rootScope, $timeout) ->

  class Base

    constructor: (data) ->
      @deleted = false
      @updateModel(data)

    updateModel: (data) ->
      if data
        @_data = data
      if data
        for n,m of data
          if typeof(m) != 'function'
            @[n] = m
      if @_data && @_data.$href
        @self = @_data.$href("self")
        # append get functions for all links...
        # for exmaple if the embedded object contains a link to 'people' we create two functions:
        # getPeople()  - which resolves eventaully to an array of People (this may take a few digest loops). This is good for use in views
        # getPeoplePromise()  -  which always returns a promise of the object - which is useful in controllers
        links = @$links()
        @__linkedData = {}
        @__linkedPromises = {}
        for link, obj of links
          name = @_snakeToCamel("get_" + link)
          do (link, obj, name) =>
            if !@[name]
              @[name] = (options) -> @$buildOject(link, options, obj)
            if !@["$" + name]
              @["$" + name] = (options) -> @$buildOjectPromise(link, options, obj)


    _snakeToCamel: (s) ->
      s.replace /(\_\w)/g, (m) -> return m[1].toUpperCase()


    # build out a linked object
    $buildOject: (link, options, obj) ->
      url = if obj.templated then new UriTemplate(obj.href).fillFromObject(options || {}) else obj.href

      return @__linkedData[url] if @__linkedData[url]
      @$buildOjectPromise(link, options, obj).then (ans) =>
        @__linkedData[url] = ans
        # re-set it again with a digest loop - jsut to be sure!
        $timeout () =>
          @__linkedData[url] = ans
      return null

    # build a promise for a linked object
    $buildOjectPromise: (link, options, obj) ->
      url = if obj.templated then new UriTemplate(obj.href).fillFromObject(options || {}) else obj.href

      return @__linkedPromises[url] if @__linkedPromises[url]
      prom = $q.defer()
      @__linkedPromises[url] = prom.promise

      @$get(link, options).then (res) =>
        inj = $injector.get('BB.Service.' + link)
        if inj
          if inj.promise
            # unwrap involving another promise
            inj.unwrap(res).then (ans) ->
              prom.resolve(ans)
            , (err) -> prom.reject(err)
          else
            # unwrap without a promise
            prom.resolve(inj.unwrap(res))
        else
          # no service found - just return the resources as I found it
          prom.resolve(res)
      , (err) -> prom.reject(err)

      @__linkedPromises[url]


    get: (ikey) ->
      return null if !@_data
      return @_data[ikey]

    set: (ikey, value) ->
      return null if !@_data
      @_data[ikey] = value

    getOption: (ikey) ->
      return null if !@_data
      return @_data.getOption(ikey)

    setOption: (ikey, value) ->
      return null if !@_data
      return @_data.setOption(ikey, value)


    $href: (rel, params) ->
      @_data.$href(rel, params) if @_data

    $has: (rel) ->
      @_data.$has(rel) if @_data

    $flush: (rel, params) ->
      @_data.$flush(rel, params) if @_data

    $get: (rel, params) ->
      @_data.$get(rel, params) if @_data

    $post: (rel, params, dat) ->
      @_data.$post(rel, params, dat) if @_data

    $put: (rel, params, dat) ->
      @_data.$put(rel, params, dat) if @_data

    $patch: (rel, params, dat) ->
      @_data.$patch(rel, params, dat) if @_data

    $del: (rel, params, dat) ->
      @_data.$del(rel, params, dat) if @_data

    $links: () ->
      @_data.$links() if @_data

    $link: (rel) ->
      @_data.$link(rel) if @_data

    $toStore: () ->
      @_data.$toStore() if @_data

