'use strict';


###**
* @ngdoc service
* @name BB.Models:PurchaseTotal
*
* @description
* Representation of an Purchase Total Object
*
* @property {integer} total_price The total price
* @property {integer} price The booking price
* @property {integer} paid Booking paid
* @property {integer} id The purchase id
####


angular.module('BB.Models').factory "Purchase.TotalModel", ($q, $window, BBModel, BaseModel, $sce) ->


  class Purchase_Total extends BaseModel
    constructor: (data) ->
      super(data)
      @getItems().then (items) =>
        @items = items
      @getClient().then (client) =>
        @client = client


    id: ->
      @get('id')

    icalLink: ->
      @_data.$href('ical')

    webcalLink: ->
      @_data.$href('ical')

    gcalLink: ->
      @_data.$href('gcal')

    ###**
    * @ngdoc method
    * @name getItems
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get items for purchase
    *
    * @returns {Promise} Returns a promise that resolve the purchase items
    ###
    getItems: =>
      defer = $q.defer()
      defer.resolve(@items) if @items
      $q.all([
        @getBookingsPromise(),
        @getCourseBookingsPromise(),
        @getPackages(),
        @getProducts(),
        @getDeals()
      ]).then (result) ->
        items = _.flatten(result)
        defer.resolve(items)
      defer.promise

    ###**
    * @ngdoc method
    * @name getBookingsPromise
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get bookings promise
    *
    * @returns {Promise} Returns a promise that resolve the bookings promise
    ###
    getBookingsPromise: =>
      defer = $q.defer()
      defer.resolve(@bookings) if @bookings
      if @_data.$has('bookings')
        @_data.$get('bookings').then (bookings) =>
          @bookings = (new BBModel.Purchase.Booking(b) for b in bookings)
          @bookings.sort (a, b) => a.datetime.unix() - b.datetime.unix()
          defer.resolve(@bookings)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name getCourseBookingsPromise
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get course bookings promise
    *
    * @returns {Promise} Returns a promise that resolve the course bookings promise
    ###
    getCourseBookingsPromise: =>
      defer = $q.defer()
      defer.resolve(@course_bookings) if @course_bookings
      if @_data.$has('course_bookings')
        @_data.$get('course_bookings').then (bookings) =>
          @course_bookings = (new BBModel.Purchase.CourseBooking(b) for b in bookings)
          $q.all(_.map(@course_bookings, (b) -> b.getBookings())).then () =>
            defer.resolve(@course_bookings)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name getPackages
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get packages
    *
    * @returns {Promise} Returns a promise that resolve the packages
    ###
    getPackages: =>
      defer = $q.defer()
      defer.resolve(@packages) if @packages
      if @_data.$has('packages')
        @_data.$get('packages').then (packages) =>
          @packages = packages
          defer.resolve(@packages)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name getProducts
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get products
    *
    * @returns {Promise} Returns a promise that resolve the products
    ###
    getProducts: =>
      defer = $q.defer()
      defer.resolve(@products) if @products
      if @_data.$has('products')
        @_data.$get('products').then (products) =>
          @products = products
          defer.resolve(@products)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name getDeals
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get deals
    *
    * @returns {Promise} Returns a promise that resolve the deals
    ###
    getDeals: =>
      defer = $q.defer()
      defer.resolve(@deals) if @deals
      if @_data.$has('deals')
        @_data.$get('deals').then (deals) =>
          @deals = deals
          defer.resolve(@deals)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name getMessages
    * @methodOf BB.Models:PurchaseTotal
    * @param {string} booking_texts The texts of the booking
    * @param {array} msg_type The type of the messages
    * @description
    * Get messages in according of the booking_texts and msg_type parameters
    *
    * @returns {Promise} Returns a promise that resolve the messages
    ###
    getMessages: (booking_texts, msg_type) =>
      defer = $q.defer()
      booking_texts = (bt for bt in booking_texts when bt.message_type == msg_type)
      if booking_texts.length == 0
        defer.resolve([])
      else
        @getItems().then (items) ->
          msgs = []
          for booking_text in booking_texts
            for item in items
              for type in ['company','person','resource','service']
                if item.$has(type) && item.$href(type) == booking_text.$href('item')
                  if msgs.indexOf(booking_text.message) == -1
                    msgs.push(booking_text.message)
          defer.resolve(msgs)
      defer.promise

    ###**
    * @ngdoc method
    * @name getClient
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the client
    *
    * @returns {Promise} Returns a promise that resolve the client
    ###
    getClient: =>
      defer = $q.defer()
      if @_data.$has('client')
        @_data.$get('client').then (client) =>
          @client = new BBModel.Client(client)
          defer.resolve(@client)
      else
        defer.reject('No client')
      defer.promise

    ###**
    * @ngdoc method
    * @name getConfirmMessages
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the confirm messages
    *
    * @returns {Promise} Returns a promise that resolve the message confirmation
    ###
    getConfirmMessages: () =>
      defer = $q.defer()
      if @_data.$has('confirm_messages')
        @_data.$get('confirm_messages').then (msgs) =>
          @getMessages(msgs, 'Confirm').then (filtered_msgs) =>
            defer.resolve(filtered_msgs)
      else
        defer.reject('no messages')
      defer.promise
      
    ###**
    * @ngdoc method
    * @name printed_total_price
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Print the total price
    *
    * @returns {integer} Returns the total price
    ###
    printed_total_price: () ->
      return "£" + parseInt(@total_price) if parseFloat(@total_price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@total_price))

    ###**
    * @ngdoc method
    * @name newPaymentUrl
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * New payment url
    *
    * @returns {string} Returns the new payment url
    ###
    newPaymentUrl: () ->
      if @_data.$has('new_payment')
        $sce.trustAsResourceUrl(@_data.$href('new_payment'))

    ###**
    * @ngdoc method
    * @name totalDuration
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Total duration of the booking
    *
    * @returns {date} Returns the duration
    ###
    totalDuration: () ->
      duration = 0
      for item in @items
        duration += item.duration if item.duration
      return duration

    ###**
    * @ngdoc method
    * @name containsWaitlistItems
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Verify if wait list contains items
    *
    * @returns {boolean} Returns true or false
    ###
    containsWaitlistItems: () ->
      waitlist = []
      for item in @items
        if item.on_waitlist == true
          waitlist.push(item)
      return if waitlist.length > 0 then true else false

