'use strict'


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
      @reviewed = false

    ###**
    * @ngdoc method
    * @name addItem
    * @methodOf BB.Models:Basket
    * @description
    * Adds an item to the items array of the basket
    *
    ###
    addItem: (item) ->
      # check if the item is already in the basket
      for i in @items
        if i is item
          return
        if i.id and item.id and i.id is item.id
          return
      @items.push(item)

    ###**
    * @ngdoc method
    * @name clear
    * @methodOf BB.Models:Basket
    * @description
    * Empty items array
    *
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
    ###
    clearItem: (item) ->
      @items = @items.filter (i) -> i isnt item

    ###**
    * @ngdoc method
    * @name itemsReady
    * @methodOf BB.Models:Basket
    * @description
    * Use to check if the basket is ready to checkout
    *
    * @returns {boolean} Flag to indicate if basket is ready checkout
    ###
    itemsReady: ->
      if @items.length > 0
        ready = true
        for i in @items
          if not i.checkReady()
            ready = false

        ready
      else
        return false

    ###**
    * @ngdoc method
    * @name readyToCheckout
    * @methodOf BB.Models:Basket
    * @description
    * Use to check if the basket is ready to checkout - and has been reviews
    *
    * @returns {boolean} Flag to indicate if basket is ready checkout
    ###
    readyToCheckout: ->
      if @items.length > 0 && @reviewed
        ready = true
        for i in @items
          if not i.checkReady()
            ready = false

        ready
      else
        return false

    ###**
    * @ngdoc method
    * @name timeItems
    * @methodOf BB.Models:Basket
    * @description
    * Returns an array of time items (i.e. event and appointment bookings)
    *
    * @returns {array}
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
    * Indicates if the basket contains time items (i.e. event and appointment bookings)
    *
    * @returns {boolean}
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
    * Gets all BasketItem's that are not coupons
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
    * Gets all external purchases in the basket
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
    * Checks if the basket contains an wait list event
    *
    * @returns {boolean} true or false
    ###
    hasWaitlistItem : ->
      for item in @items
        return true if item.isWaitlist()
      return false

    ###**
    * @ngdoc method
    * @name hasExternalPurchase
    * @methodOf BB.Models:Basket
    * @description
    * Checks if the basket contains an external purchase
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
    * Indicates if a wallet should be used for payment
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

    $applyCoupon: (company, params) ->
        BasketService.applyCoupon(company, params)

    @$updateBasket: (company, params) ->
      BasketService.updateBasket(company, params)

    $deleteItem: (item, company, params) ->
        BasketService.deleteItem(item, company, params)

    @$checkout: (company, basket, params) ->
        BasketService.checkout(company, basket, params)

    $empty: (bb) ->
        BasketService.empty (bb)

    $applyDeal: (company, params) ->
        BasketService.applyDeal(company, params)

    $removeDeal: (company, params) ->
        BasketService.removeDeal(company, params)

    ###**
    * @ngdoc method
    * @name voucherRemainder
    * @methodOf BB.Models:Basket
    * @description
    * Remaining voucher value if used
    *
    * @returns {integer} remaining voucher value
    ###
    voucherRemainder : ->
      amount = 0
      for item in @items
          amount += item.voucher_remainder if item.voucher_remainder
      return amount

