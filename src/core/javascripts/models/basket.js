// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
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
*///


angular.module('BB.Models').factory("BasketModel", ($q, BBModel, BaseModel, BasketService) =>

  class Basket extends BaseModel {

    constructor(data, scope) {
      super(data);
      if (scope && scope.isAdmin) {
        this.is_admin = scope.isAdmin;
      } else {
        this.is_admin = false;
      }
      if ((scope != null) && scope.parent_client) {
        this.parent_client_id = scope.parent_client.id;
      }
      this.items = [];
      this.reviewed = false;
    }
    /***
    * @ngdoc method
    * @name addItem
    * @methodOf BB.Models:Basket
    * @description
    * Adds an item to the items array of the basket
    *
    */
    addItem(item) {
      // check if the item is already in the basket
      for (let i of Array.from(this.items)) {
        if (i === item) {
          return;
        }
        if (i.id && item.id && (i.id === item.id)) {
          return;
        }
      }
      return this.items.push(item);
    }

    /***
    * @ngdoc method
    * @name clear
    * @methodOf BB.Models:Basket
    * @description
    * Empty items array
    *
    */
    clear() {
      return this.items = [];
    }

    /***
    * @ngdoc method
    * @name clearItem
    * @methodOf BB.Models:Basket
    * @description
    * Remove a given item from the items array
    *
    */
    clearItem(item) {
      return this.items = this.items.filter(i => i !== item);
    }

    /***
    * @ngdoc method
    * @name itemsReady
    * @methodOf BB.Models:Basket
    * @description
    * Use to check if the basket is ready to checkout
    *
    * @returns {boolean} Flag to indicate if basket is ready checkout
    */
    itemsReady() {
      if (this.items.length > 0) {
        let ready = true;
        for (let i of Array.from(this.items)) {
          if (!i.checkReady()) {
            ready = false;
          }
        }

        return ready;
      } else {
        return false;
      }
    }

    /***
    * @ngdoc method
    * @name readyToCheckout
    * @methodOf BB.Models:Basket
    * @description
    * Use to check if the basket is ready to checkout - and has been reviews
    *
    * @returns {boolean} Flag to indicate if basket is ready checkout
    */
    readyToCheckout() {
      if ((this.items.length > 0) && this.reviewed) {
        let ready = true;
        for (let i of Array.from(this.items)) {
          if (!i.checkReady()) {
            ready = false;
          }
        }

        return ready;
      } else {
        return false;
      }
    }

    /***
    * @ngdoc method
    * @name timeItems
    * @methodOf BB.Models:Basket
    * @description
    * Returns an array of time items (i.e. event and appointment bookings)
    *
    * @returns {array}
    */
    timeItems() {
      let titems = [];
      for (let i of Array.from(this.items)) {
        if (i.isTimeItem()) { titems.push(i); }
      }
      return titems;
    }

    /***
    * @ngdoc method
    * @name hasTimeItems
    * @methodOf BB.Models:Basket
    * @description
    * Indicates if the basket contains time items (i.e. event and appointment bookings)
    *
    * @returns {boolean}
    */
    hasTimeItems() {
      for (let i of Array.from(this.items)) {
        if (i.isTimeItem()) { return true; }
      }
      return false;
    }


    /***
    * @ngdoc method
    * @name basketItems
    * @methodOf BB.Models:Basket
    * @description
    * Gets all BasketItem's that are not coupons
    *
    * @returns {array} array of basket items
    */
    basketItems() {
      let bitems = [];
      for (let i of Array.from(this.items)) {
        if (!i.is_coupon) { bitems.push(i); }
      }
      return bitems;
    }


    /***
    * @ngdoc method
    * @name externalPurchaseItems
    * @methodOf BB.Models:Basket
    * @description
    * Gets all external purchases in the basket
    *
    * @returns {array} array of external purchases
    */
    externalPurchaseItems() {
      let eitems = [];
      for (let i of Array.from(this.items)) {
        if (i.isExternalPurchase()) { eitems.push(i); }
      }
      return eitems;
    }


    /***
    * @ngdoc method
    * @name couponItems
    * @methodOf BB.Models:Basket
    * @description
    * Build an array of items that are coupons
    *
    * @returns {array} the newly build array of coupon items
    */
    couponItems() {
      let citems = [];
      for (let i of Array.from(this.items)) {
        if (i.is_coupon) { citems.push(i); }
      }
      return citems;
    }

    /***
    * @ngdoc method
    * @name removeCoupons
    * @methodOf BB.Models:Basket
    * @description
    * Remove coupon items from the items array
    *
    * @returns {array} the items array after removing items that are coupons
    */
    removeCoupons() {
      return this.items = _.reject(this.items, x => x.is_coupon);
    }

    /***
    * @ngdoc method
    * @name setSettings
    * @methodOf BB.Models:Basket
    * @description
    * Extend the settings with the set param passed to the function
    *
    * @returns {object} settings object
    */
    setSettings(set) {
      if (!set) { return; }
      if (!this.settings) { this.settings = {}; }
      return $.extend(this.settings, set);
    }

    /***
    * @ngdoc method
    * @name setClient
    * @methodOf BB.Models:Basket
    * @description
    * Set the client
    *
    * @returns {object} client object
    */
    setClient(client) {
      return this.client = client;
    }

    /***
    * @ngdoc method
    * @name setClientDetails
    * @methodOf BB.Models:Basket
    * @description
    * Set client details
    *
    * @returns {object} client details
    */
    setClientDetails(client_details) {
      return this.client_details = new BBModel.PurchaseItem(client_details);
    }

    /***
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:Basket
    * @description
    * Build an array with details for every item in items array
    *
    * @returns {array} newly created details array
    */
    getPostData() {
      let post = {
        client: this.client.getPostData(),
        settings: this.settings,
        reference: this.reference
      };
      post.is_admin = this.is_admin;
      post.parent_client_id = this.parent_client_id;
      post.take_from_wallet = this.take_from_wallet;
      post.items = [];
      for (let item of Array.from(this.items)) {
        post.items.push(item.getPostData());
      }
      return post;
    }

    /***
    * @ngdoc method
    * @name dueTotal
    * @methodOf BB.Models:Basket
    * @description
    * Total price after checking every item if it is on the wait list
    *
    * @returns {integer} total
    */
    // the amount due now - taking account of any wait list items
    dueTotal() {
      let total = this.totalPrice();
      for (let item of Array.from(this.items)) {
        if (item.isWaitlist()) { total -= item.price; }
      }
      if (total < 0) { total = 0; }
      return total;
    }

    /***
    * @ngdoc method
    * @name length
    * @methodOf BB.Models:Basket
    * @description
    * Length of the items array
    *
    * @returns {integer} length
    */
    length() {
      return this.items.length;
    }

    /***
    * @ngdoc method
    * @name questionPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates total question's price
    *
    * @returns {integer} question's price
    */
    questionPrice(options) {
      let unready = options && options.unready;
      let price = 0;
      for (let item of Array.from(this.items)) {
        if ((!item.ready && unready) || !unready) { price += item.questionPrice(); }
      }
      return price;
    }

    /***
    * @ngdoc method
    * @name totalPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates total price of the items after coupuns have been applied
    *
    * @returns {integer} total price
    */
    // return the total price after coupons have been applied
    totalPrice(options) {
      let unready = options && options.unready;
      let price = 0;
      for (let item of Array.from(this.items)) {
        if ((!item.ready && unready) || !unready) { price += item.totalPrice(); }
      }
      return price;
    }

    /***
    * @ngdoc method
    * @name updateTotalPrice
    * @methodOf BB.Models:Basket
    * @description
    * Update the total_price attribute using totalPrice method
    *
    * @returns {integer} the updated total_price variable
    */
    updateTotalPrice(options) {
      return this.total_price = this.totalPrice(options);
    }

    /***
    * @ngdoc method
    * @name fullPrice
    * @methodOf BB.Models:Basket
    * @description
    * Calculates full price of all items, before applying any coupons or deals
    *
    * @returns {integer} full price
    */
    // return the full price before any coupons or deals have been applied
    fullPrice() {
      let price = 0;
      for (let item of Array.from(this.items)) {
        price += item.fullPrice();
      }
      return price;
    }

    /***
    * @ngdoc method
    * @name hasCoupon
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is an item in items array, that is a coupon
    *
    * @returns {boolean} true or false if a coupon is found or not
    */
    hasCoupon() {
      for (let item of Array.from(this.items)) {
        if (item.is_coupon) { return true; }
      }
      return false;
    }

    /***
    * @ngdoc method
    * @name totalCoupons
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the full discount for the basket
    *
    * @returns {integer} full discount
    */
    // return the total coupon discount applied to the basket
    totalCoupons() {
      return this.fullPrice() - this.totalPrice() - this.totalDealPaid();
    }

    /***
    * @ngdoc method
    * @name totalDuration
    * @methodOf BB.Models:Basket
    * @description
    * Calculates total duration of all items in basket
    *
    * @returns {integer} total duration
    */
    totalDuration() {
      let duration = 0;
      for (let item of Array.from(this.items)) {
        if (item.service && item.service.listed_duration) { duration += item.service.listed_duration; }
      }
      return duration;
    }

    /***
    * @ngdoc method
    * @name containsDeal
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is an item in items array, that is a deal
    *
    * @returns {boolean} true or false depending if a deal was found or not
    */
    containsDeal() {
      for (let item of Array.from(this.items)) {
        if (item.deal_id) { return true; }
      }
      return false;
    }

    /***
    * @ngdoc method
    * @name hasDeal
    * @methodOf BB.Models:Basket
    * @description
    * Checks if there is any item in items array with a deal code
    *
    * @returns {boolean} true or false depending if a deal code was found or not
    */
    hasDeal() {
      for (let item of Array.from(this.items)) {
        if (item.deal_codes && (item.deal_codes.length > 0)) { return true; }
      }
      return false;
    }

    /***
    * @ngdoc method
    * @name getDealCodes
    * @methodOf BB.Models:Basket
    * @description
    * Builds an array of deal codes
    *
    * @returns {array} deal codes array
    */
    getDealCodes() {
      this.deals = this.items[0] && this.items[0].deal_codes ? this.items[0].deal_codes : [];
      return this.deals;
    }

    /***
    * @ngdoc method
    * @name totalDeals
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the total amount of deal codes array
    *
    * @returns {integer} total amount of deals
    */
    // return the total value of deals (gift certificates) applied to the basket
    totalDeals() {
      let value = 0;
      for (let deal of Array.from(this.getDealCodes())) {
        value += deal.value;
      }
      return value;
    }

    /***
    * @ngdoc method
    * @name totalDealPaid
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the amount paid by gift certificates
    *
    * @returns {integer} amount paid by deals
    */
    // return amount paid by deals (gift certficates)
    totalDealPaid() {
      let total_cert_paid = 0;
      for (let item of Array.from(this.items)) {
        if (item.certificate_paid) { total_cert_paid += item.certificate_paid; }
      }
      return total_cert_paid;
    }

    /***
    * @ngdoc method
    * @name remainingDealBalance
    * @methodOf BB.Models:Basket
    * @description
    * Calculates the difference between total deals amount and amount paid by deals
    *
    * @returns {integer} The remaining deal (gift certificate) balance
    */
    // return the remaining deal (gift certificate) balance
    remainingDealBalance() {
      return this.totalDeals() - this.totalDealPaid();
    }

    /***
    * @ngdoc method
    * @name hasWaitlistItem
    * @methodOf BB.Models:Basket
    * @description
    * Checks if the basket contains an wait list event
    *
    * @returns {boolean} true or false
    */
    hasWaitlistItem() {
      for (let item of Array.from(this.items)) {
        if (item.isWaitlist()) { return true; }
      }
      return false;
    }

    /***
    * @ngdoc method
    * @name hasExternalPurchase
    * @methodOf BB.Models:Basket
    * @description
    * Checks if the basket contains an external purchase
    *
    * @returns {boolean} true or false
    */
    hasExternalPurchase() {
      for (let item of Array.from(this.items)) {
        if (item.isExternalPurchase()) { return true; }
      }
      return false;
    }

    /***
    * @ngdoc method
    * @name useWallet
    * @methodOf BB.Models:Basket
    * @description
    * Indicates if a wallet should be used for payment
    *
    * @returns {boolean} true or false
    */
    useWallet(value, client) {
      if (client && client.$has('wallet') && value) {
        this.take_from_wallet = true;
        return true;
      } else {
        this.take_from_wallet = false;
        return false;
      }
    }

    static $applyCoupon(company, params) {
        return BasketService.applyCoupon(company, params);
      }

    static $updateBasket(company, params) {
      return BasketService.updateBasket(company, params);
    }

    static $deleteItem(item, company, params) {
        return BasketService.deleteItem(item, company, params);
      }

    static $checkout(company, basket, params) {
        return BasketService.checkout(company, basket, params);
      }

    static $empty(bb) {
        return BasketService.empty((bb));
      }

    static $applyDeal(company, params) {
        return BasketService.applyDeal(company, params);
      }

    static $removeDeal(company, params) {
        return BasketService.removeDeal(company, params);
      }

    /***
    * @ngdoc method
    * @name voucherRemainder
    * @methodOf BB.Models:Basket
    * @description
    * Remaining voucher value if used
    *
    * @returns {integer} remaining voucher value
    */
    voucherRemainder() {
      let amount = 0;
      for (let item of Array.from(this.items)) {
        if (item.voucher_remainder) { amount += item.voucher_remainder; }
      }
      return amount;
    }
  }
);

