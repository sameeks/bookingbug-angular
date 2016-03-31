'use strict';

###**
* @ngdoc service
* @name BB.Models:Basket
*
* @description
* Representation of an Basket Object.
*
* @property {number} company_id Company id that the basket belongs to
* @property {number} total_price Total price of the basket
* @property {number} total_due_price Total price of the basket after applying discounts
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
    * Adds an item to the items array.
    *
    * @param {object} item Item that must be added
    *
    * @returns {array} Array with the newly added item
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
    * Removes the items from basket.
    *
    ###
    clear: () ->
      @items = []

    ###**
    * @ngdoc method
    * @name clearItem
    * @methodOf BB.Models:Basket
    * @description
    * Removes a given item from the items array.
    *
    * @param {object} item Item that must be removed
    *
    * @returns {array} Array without the given item
    ###
    clearItem: (item) ->
      @items = @items.filter (i) -> i isnt item

    ###**
    * @ngdoc method
    * @name readyToCheckout
    * @methodOf BB.Models:Basket
    * @description
    * Checks if the items array is not empty and it's ready for the checkout.
    *
    * @returns {boolean} If items array is not empty
    ###
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
    * Builds an array of time items(all the items that are not coupons).
    *
    * @returns {array} Newly created array of time items
    ###
    timeItems: ->
      titems = []
      for i in @items
        titems.push(i) if i.isTimeItem()
      titems

    ###**
    * @ngdoc method
    * @name hasTimeItems
    * @methodOf BB.Models:Basket
    * @description
    * Indicates if the basket contains time items (i.e. event and appointment bookings).
    *
    ###
    hasTimeItems: ->
      for i in @items
        return true if i.isTimeItem()
      return false

    ###**
    * @ngdoc method
    * @name basketItems
    * @methodOf BB.Models:Basket
    * @description
    * Gets all BasketItem's that are not coupons.
    *
    * @returns {array} array of basket items
    ###
    basketItems: ->
      bitems = []
      for i in @items
        bitems.push(i) if !i.is_coupon
      bitems

    ###**
    * @ngdoc method
    * @name externalPurchaseItems
    * @methodOf BB.Models:Basket
    * @description
    * Gets all external purchases in the basket.
    *
    * @returns {array} array of external purchases
    ###
    externalPurchaseItems: ->
      eitems = []
      for i in @items
        eitems.push(i) if i.isExternalPurchase()
      eitems

    ###**
    * @ngdoc method
    * @name couponItems
    * @methodOf BB.Models:Basket
    * @description
    * Builds an array of items that are coupons.
    *
    * @returns {array} Newly created array of coupon items
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
    * Removes the coupon items from the items array.
    *
    * @returns {array} Items array after removing items that are coupons
    ###
    removeCoupons: ->
      @items = _.reject @items, (x) -> x.is_coupon

    ###**
    * @ngdoc method
    * @name setSettings
    * @methodOf BB.Models:Basket
    * @description
    * Extends the settings with the set param passed to the function.
    *
    * @param {object} set set parameter
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
    * Sets the client.
    *
    * @param {object} client Client
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
    * Sets the client details.
    *
    * @param {object} client_details Client details
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
    * Builds an array with the details for every item in the basket.
    *
    * @returns {array} Newly created details array
    ###
    getPostData: ->
      post =
        client: @client.getPostData()
        settings: @settings
        reference: @reference
      post.is_admin = @is_admin
      post.parent_client_id = @parent_client_id
      post.take_from_wallet = @take_from_wallet
      post.items = []
      for item in @items
        post.items.push(item.getPostData())
      return post

    ###**
    * @ngdoc method
    * @name dueTotal
    * @methodOf BB.Models:Basket
    * @description
    * Gets the total price after checking every item if it's on the wait list.
    *
    * @returns {number} Total price
    ###
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
    * Gets the items array lenght.
    *
    * @returns {number} length
    ###
    length: ->
      @items.length

    ###**
    * @ngdoc method
    * @name questionPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the total question's price.
    *
    * @returns {number} question's price
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
    * Calculates the total price of the items after the coupons have been applied.
    *
    * @param {object} options options parameter
    *
    * @returns {number} Total price
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
    * Updates the total_price attribute using totalPrice method.
    *
    * @param {object} options options parameter
    *
    * @returns {number} Updated total_price variable
    ###
    updateTotalPrice: (options) ->
      @total_price = @totalPrice(options)

    ###**
    * @ngdoc method
    * @name fullPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the full price of all items, before applying any coupons or deals.
    *
    * @returns {number} Full price
    ###
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
    * Checks if the basket has an item that is a coupon.
    *
    * @returns {boolean} True if an item was found, false otherwise
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
    * Calculates the coupons full discount.
    *
    * @returns {number} Total coupon discount applied to the basket
    ###
    totalCoupons: ->
      @fullPrice() - @totalPrice() - @totalDealPaid()

    ###**
    * @ngdoc method
    * @name totalDuration
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the basket items total duration.
    *
    * @returns {number} Total duration
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
    * Checks if the basket has an item that is a deal.
    *
    * @returns {boolean} True if an item was found, false otherwise
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
    * Checks if the basket has an item that contains at least one deal code.
    *
    * @returns {boolean} True if an item was found, false otherwise
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
    * Builds an array of deal codes.
    *
    * @returns {array} Deal codes
    ###
    getDealCodes: ->
      @deals = if @items[0] && @items[0].deal_codes then @items[0].deal_codes else []
      @deals

    ###**
    * @ngdoc method
    * @name totalDeals
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the deal codes total amount.
    *
    * @returns {number} The total value of deals (gift certificates) applied to the basket
    ###
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
    * Calculates the amount paid by gift certificates.
    *
    * @returns {number} Amount paid by deals (gift certficates)
    ###
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
    * Calculates the difference between total deals amount and amount paid by deals.
    *
    * @returns {number} The remaining deal (gift certificate) balance
    ###
    remainingDealBalance : ->
      return @totalDeals() - @totalDealPaid()

    ###**
    * @ngdoc method
    * @name hasWaitlistItem
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is an item in the bakset that's on the wait list.
    *
    * @returns {boolean} True or false
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
    * Static function that loads the basket items from a company object.
    *
    * @returns {promise} A promise that on success will return the basket items
    ###
    @$query: (company,params) ->
      BasketService.query(company, params)

    ###**
    * @ngdoc method
    * @name $checkout
    * @methodOf BB.Models:Basket
    * @description
    * Static function that makes the checkout operation on a basket.
    *
    * @returns {promise} A promise that on success clears the basket and will trigger some updates on bookings
    ###
    $checkout: (company,basket,params) ->
      BasketService.checkout(company,basket,params)

    ###**
    * @ngdoc method
    * @name hasExternalPurchase
    * @methodOf BB.Models:Basket
    * @description
    * Checks if the basket contains an external purchase.
    *
    * @returns {boolean} true or false
    ###
    hasExternalPurchase : ->
      for item in @items
        return true if item.isExternalPurchase()
      return false

    ###**
    * @ngdoc method
    * @name useWallet
    * @methodOf BB.Models:Basket
    * @description
    * Indicates if a wallet should be used for payment.
    *
    * @param {number} value value parameter
    * @param {object} client Client object
    *
    * @returns {boolean} true or false
    ###
    useWallet : (value, client) ->
      if client and client.$has('wallet') and value
        @take_from_wallet = true
        return true
      else
        @take_from_wallet = false
        return false

    ###**
    * @ngdoc method
    * @name $applyCoupon
    * @methodOf BB.Models:Basket
    * @description
    * Applies coupon discounts on the basket.
    *
    * @param {object} company company parameter
    * @param {object} params params parameter
    *
    * @returns {promise} A returned promise
    ###
    $applyCoupon: (company, params) ->
        BasketService.applyCoupon(company, params)

    ###**
    * @ngdoc method
    * @name $updateBasket
    * @methodOf BB.Models:Basket
    * @description
    * Updates the basket.
    *
    * @param {object} company company parameter
    * @param {object} params params parameter
    *
    * @returns {promise} A returned promise
    ###
    @$updateBasket: (company, params) ->
      BasketService.updateBasket(company, params)

    ###**
    * @ngdoc method
    * @name $deleteItem
    * @methodOf BB.Models:Basket
    * @description
    * Deletes an item from the basket.
    *
    * @param {object} item item parameter
    * @param {object} company company parameter
    * @param {object} params params parameter
    *
    * @returns {promise} A returned promise
    ###
    $deleteItem: (item, company, params) ->
        BasketService.deleteItem(item, company, params)

    ###**
    * @ngdoc method
    * @name $empty
    * @methodOf BB.Models:Basket
    * @description
    * Empties the basket.
    *
    * @param {object} bb bb parameter
    *
    * @returns {promise} A returned promise
    ###
    $empty: (bb) ->
        BasketService.empty (bb)

    ###**
    * @ngdoc method
    * @name $applyDeal
    * @methodOf BB.Models:Basket
    * @description
    * Applies a deal to the basket.
    *
    * @param {object} company company parameter
    * @param {object} params params parameter
    *
    * @returns {promise} A returned promise
    ###
    $applyDeal: (company, params) ->
        BasketService.applyDeal(company, params)

    ###**
    * @ngdoc method
    * @name $removeDeal
    * @methodOf BB.Models:Basket
    * @description
    * Removes the deal from basket.
    *
    * @param {object} company company parameter
    * @param {object} params params parameter
    *
    * @returns {promise} A returned promise
    ###
    $removeDeal: (company, params) ->
        BasketService.removeDeal(company, params)
