'use strict';


###**
* @ngdoc service
* @name BB.Models:Basket
*
* @description
* Representation of an Basket Object
*
* @property {integer} company_id Company id that the basket belongs to 
* @property {integer} total_price Total price of the basket
* @property {integer} total_due_price Total price of the basket after applying discounts
* @property {array} items Array of items that are in the basket
####


angular.module('BB.Models').factory "BasketModel", ($q, BBModel, BaseModel, BasketService) ->

  class Basket extends BaseModel
    constructor: (data, scope) ->
      if scope && scope.isAdmin
        @is_admin = scope.isAdmin
      else
        @is_admin = false
      if scope? && scope.parent_client
        @parent_client_id = scope.parent_client.id
      @items = []
      super(data)

    ###**
    * @ngdoc method
    * @name addItem
    * @methodOf BB.Models:Basket
    * @description
    * Adds an item to the items array of the basket
    *
    * @returns {array} items Array with the newly added item
    ###
    addItem: (item) ->
      # check if then item is already in the basket
      for i in @items
        if i == item
          return
        if i.id && item.id && i.id == item.id
          return
      @items.push(item)

    ###**
    * @ngdoc method
    * @name clear
    * @methodOf BB.Models:Basket
    * @description
    * Empty items array
    *
    * @returns {array} Emptied items array
    ###
    clear: () ->
      @items = []

    ###**
    * @ngdoc method
    * @name clearItem
    * @methodOf BB.Models:Basket
    * @description
    * Remove a given item from the items array
    *
    * @returns {array} items Array without the given item
    ###
    clearItem: (item) ->
      @items = @items.filter (i) -> i isnt item

    ###**
    * @ngdoc method
    * @name readyToCheckout
    * @methodOf BB.Models:Basket
    * @description
    * Checks if items array is not empty, so it's ready for the checkout
    *
    * @returns {boolean} If items array is not empty
    ###
    # should we try to checkout ?
    readyToCheckout: ->
      if @items.length > 0
        return true
      else
        return false

    ###**
    * @ngdoc method
    * @name timeItems
    * @methodOf BB.Models:Basket
    * @description
    * Build an array of time items(all items that are not coupons)
    *
    * @returns {array} the newly build array of items
    ###
    timeItems: ->
      titems = []
      for i in @items
        titems.push(i) if !i.is_coupon #and !i.ready
      titems

    ###**
    * @ngdoc method
    * @name couponItems
    * @methodOf BB.Models:Basket
    * @description
    * Build an array of items that are coupons
    *
    * @returns {array} the newly build array of coupon items
    ###
    couponItems: ->
      citems = []
      for i in @items
        citems.push(i) if i.is_coupon
      citems

    ###**
    * @ngdoc method
    * @name removeCoupons
    * @methodOf BB.Models:Basket
    * @description
    * Remove coupon items from the items array
    *
    * @returns {array} the items array after removing items that are coupons
    ###
    removeCoupons: ->
      @items = _.reject @items, (x) -> x.is_coupon

    ###**
    * @ngdoc method
    * @name setSettings
    * @methodOf BB.Models:Basket
    * @description
    * Extend the settings with the set param passed to the function
    *
    * @returns {object} settings object
    ###
    setSettings: (set) ->
      return if !set
      @settings ||= {}
      $.extend(@settings, set)

    ###**
    * @ngdoc method
    * @name setClient
    * @methodOf BB.Models:Basket
    * @description
    * Set the client
    *
    * @returns {object} client object 
    ###
    setClient: (client) ->
      @client = client

    ###**
    * @ngdoc method
    * @name setClientDetails
    * @methodOf BB.Models:Basket
    * @description
    * Set client details
    *
    * @returns {object} client details 
    ###
    setClientDetails: (client_details) ->
      @client_details = new BBModel.PurchaseItem(client_details)

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:Basket
    * @description
    * Build an array with details for every item in items array
    *
    * @returns {array} newly created details array
    ###
    getPostData: ->
      post =
        client: @client.getPostData()
        settings: @settings
        reference: @reference
      post.is_admin = @is_admin
      post.parent_client_id = @parent_client_id
      post.items = []
      for item in @items
        post.items.push(item.getPostData())
      return post

    ###**
    * @ngdoc method
    * @name dueTotal
    * @methodOf BB.Models:Basket
    * @description
    * Total price after checking every item if it is on the wait list
    *
    * @returns {integer} total
    ###
    # the amount due now - taking account of any wait list items
    dueTotal: ->
      total = @totalPrice()
      for item in @items
        total -= item.price if item.isWaitlist()
      total = 0 if total < 0
      total

    ###**
    * @ngdoc method
    * @name length
    * @methodOf BB.Models:Basket
    * @description
    * Length of the items array
    *
    * @returns {integer} length
    ###
    length: ->
      @items.length

    ###**
    * @ngdoc method
    * @name questionPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates total question's price
    *
    * @returns {integer} question's price
    ###
    questionPrice: (options) ->
      unready = options and options.unready
      price = 0
      for item in @items
        price += item.questionPrice() if (!item.ready and unready) or !unready
      return price

    ###**
    * @ngdoc method
    * @name totalPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates total price of the items after coupuns have been applied
    *
    * @returns {integer} total price
    ###
    # return the total price after coupons have been applied
    totalPrice: (options) ->
      unready = options and options.unready
      price = 0
      for item in @items
        price += item.totalPrice() if (!item.ready and unready) or !unready
      return price

    ###**
    * @ngdoc method
    * @name updateTotalPrice
    * @methodOf BB.Models:Basket
    * @description
    * Update the total_price attribute using totalPrice method
    *
    * @returns {integer} the updated total_price variable
    ###
    updateTotalPrice: (options) ->
      @total_price = @totalPrice(options)

    ###**
    * @ngdoc method
    * @name fullPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates full price of all items, before applying any coupons or deals
    *
    * @returns {integer} full price
    ###
    # return the full price before any coupons or deals have been applied
    fullPrice: ->
      price = 0
      for item in @items
        price += item.fullPrice()
      return price

    ###**
    * @ngdoc method
    * @name hasCoupon
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is an item in items array, that is a coupon
    *
    * @returns {boolean} true or false if a coupon is found or not
    ###
    hasCoupon: ->
      for item in @items
        return true if item.is_coupon
      return false

    ###**
    * @ngdoc method
    * @name totalCoupons
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the full discount for the basket
    *
    * @returns {integer} full discount
    ###  
    # return the total coupon discount applied to the basket
    totalCoupons: ->
      @fullPrice() - @totalPrice() - @totalDealPaid()
    
    ###**
    * @ngdoc method
    * @name totalDuration
    * @methodOf BB.Models:Basket
    * @description
    * Calculates total duration of all items in basket
    *
    * @returns {integer} total duration 
    ###  
    totalDuration: ->
      duration = 0
      for item in @items
        duration += item.service.listed_duration if item.service and item.service.listed_duration
      return duration

    ###**
    * @ngdoc method
    * @name containsDeal
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is an item in items array, that is a deal
    *
    * @returns {boolean} true or false depending if a deal was found or not
    ###  
    containsDeal: ->
      for item in @items
        return true if item.deal_id
      return false

    ###**
    * @ngdoc method
    * @name hasDeal
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is any item in items array with a deal code
    *
    * @returns {boolean} true or false depending if a deal code was found or not
    ###  
    hasDeal: ->
      for item in @items
        return true if item.deal_codes && item.deal_codes.length > 0
      return false

    ###**
    * @ngdoc method
    * @name getDealCodes
    * @methodOf BB.Models:Basket
    * @description
    * Builds an array of deal codes
    *
    * @returns {array} deal codes array
    ###  
    getDealCodes: ->
      @deals = if @items[0] && @items[0].deal_codes then @items[0].deal_codes else []
      @deals

    ###**
    * @ngdoc method
    * @name totalDeals
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the total amount of deal codes array
    *
    * @returns {integer} total amount of deals
    ###  
    # return the total value of deals (gift certificates) applied to the basket
    totalDeals: ->
      value = 0
      for deal in @getDealCodes()
        value += deal.value
      return value

    ###**
    * @ngdoc method
    * @name totalDealPaid
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the amount paid by gift certificates
    *
    * @returns {integer} amount paid by deals
    ### 
    # return amount paid by deals (gift certficates)
    totalDealPaid: ->
      total_cert_paid = 0
      for item in @items
        total_cert_paid += item.certificate_paid if item.certificate_paid
      return total_cert_paid

    ###**
    * @ngdoc method
    * @name remainingDealBalance
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the difference between total deals amount and amount paid by deals
    *
    * @returns {integer} The remaining deal (gift certificate) balance
    ###
    # return the remaining deal (gift certificate) balance
    remainingDealBalance : ->
      return @totalDeals() - @totalDealPaid()

    ###**
    * @ngdoc method
    * @name hasWaitlistItem
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is an item in the items array that's on the wait list
    *
    * @returns {boolean} true or false
    ### 
    hasWaitlistItem : ->
      for item in @items
        return true if item.isWaitlist()
      return false
      
    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Basket
    * @description
    * Static function that loads an array of basket from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company,params) ->
      BasketService.query(company, params)

    $checkout: (company,basket,params) ->
      BasketService.checkout(company,basket,params)