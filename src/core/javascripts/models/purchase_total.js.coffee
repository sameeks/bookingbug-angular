'use strict';

###**
* @ngdoc service
* @name BB.Models:PurchaseTotal
*
* @description
* Representation of an PurchaseTotal Object
*
* @property {number} total_price Items total price
* @property {number} price Items price
* @property {number} tax_payable_on_price The tax payable on price of the item
* @property {number} due_now due now
####

angular.module('BB.Models').factory "PurchaseTotalModel", ($q, BBModel, BaseModel, PurchaseTotalService) ->

  class PurchaseTotal extends BaseModel

    constructor: (data) ->
      super(data)
      @promise = @_data.$get('purchase_items')
      @items = []
      @promise.then (items) =>
        for item in items
          @items.push(new BBModel.PurchaseItem(item))
      if @_data.$has('client')
       cprom = data.$get('client')
       cprom.then (client) =>
         @client = new BBModel.Client(client)

    ###**
    * @ngdoc method
    * @name icalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Gets the icalLink.
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
    * Gets the  webcalLink.
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
    * Gets the gcalLink.
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
    * Gets the id.
    *
    * @returns {object} The returned id
    ###
    id: ->
      @get('id')

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Static function that loads an array of total purchase from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (prms) ->
      PurchaseTotalService.query(prms)
