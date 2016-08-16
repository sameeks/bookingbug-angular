'use strict'


###**
* @ngdoc service
* @name BB.Models:PurchaseTotal
*
* @description
* Representation of an PurchaseTotal Object
*
* @property {float} total_price The total price of items
* @property {float} price Price of items
* @property {float} tax_payable_on_price The tax payable on price of the item
* @property {float} due_now The due now
####


angular.module('BB.Models').factory "PurchaseTotalModel", ($q, BBModel,
  BaseModel, PurchaseTotalService) ->

  class PurchaseTotal extends BaseModel

    constructor: (data) ->
      super(data)
      @promise = @_data.$get('purchase_items')
      @purchase_items = []
      @promise.then (items) =>
        for item in items
          @purchase_items.push(new BBModel.PurchaseItem(item))
      if @_data.$has('client')
       cprom = data.$get('client')
       cprom.then (client) =>
         @client = new BBModel.Client(client)
      @created_at = moment.parseZone(@created_at)
      @created_at.tz(@time_zone) if @time_zone


    ###**
    * @ngdoc method
    * @name icalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the icalLink
    *
    * @returns {object} The returned icalLink
    ###
    icalLink: ->
      @_data.$href('ical')

    ###**
    * @ngdoc method
    * @name webcalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get webcalLink
    *
    * @returns {object} The returned webcalLink
    ###
    webcalLink: ->
      @_data.$href('ical')

    ###**
    * @ngdoc method
    * @name gcalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the gcalLink
    *
    * @returns {object} The returned gcalLink
    ###
    gcalLink: ->
      @_data.$href('gcal')

    ###**
    * @ngdoc method
    * @name id
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the id
    *
    * @returns {object} The returned id
    ###
    id: ->
      @get('id')

    @$query: (params) ->
      PurchaseService.query (params)

    @$bookingRefQuery: (params) ->
      PurchaseService.query (params)

