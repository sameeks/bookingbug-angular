'use strict';

###**
* @ngdoc service
* @name BB.Models:PurchaseItem
*
* @description
* Representation of an PurchaseItem Object
*
* @property {number} price Price of the purchase item
* @property {number} paid Purchase item paid
####

angular.module('BB.Models').factory "PurchaseItemModel", ($q, BBModel, BaseModel) ->

  class PurchaseItem extends BaseModel

    constructor: (data) ->
      super(data)
      @parts_links = {}
      if data
        if data.$has('service')
          @parts_links.service = data.$href('service')
        if data.$has('resource')
          @parts_links.resource = data.$href('resource')
        if data.$has('person')
          @parts_links.person = data.$href('person')
        if data.$has('company')
          @parts_links.company = data.$href('company')

    ###**
    * @ngdoc method
    * @name describe
    * @methodOf BB.Models:PurchaseItem
    * @description
    * Describes the item for purchase.
    *
    * @returns {object} The returned describe
    ###
    describe: ->
      @get('describe')

    ###**
    * @ngdoc method
    * @name full_describe
    * @methodOf BB.Models:PurchaseItem
    * @description
    * Gets the full description for a purchasable item.
    *
    * @returns {object} Full description
    ###
    full_describe: ->
      @get('full_describe')

    ###**
    * @ngdoc method
    * @name hasPrice
    * @methodOf BB.Models:PurchaseItem
    * @description
    * Checks if the purchase item has a price.
    *
    * @returns {boolean} True if purchase item has a price
    ###
    hasPrice: ->
      return (@price && @price > 0)

