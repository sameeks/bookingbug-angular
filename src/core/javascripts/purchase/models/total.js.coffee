'use strict';


###**
* @ngdoc service
* @name BB.Models:PurchaseTotal
*
* @description
* Representation of an Purchase Total Object
*
* @property {integer} total_price The total price of booking
* @property {integer} price Booking price
* @propertu {integer} paid The booking paid
####



angular.module('BB.Models').factory "Purchase.TotalModel", ($q, $window, BBModel, BaseModel, $sce, PurchaseService) ->


  class Purchase_Total extends BaseModel
    constructor: (data) ->
      super(data)
      @getItems().then (items) =>
        @items = items
      @getClient().then (client) =>
        @client = client

    ###**
    * @ngdoc method
    * @name id
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the client id
    *
    * @returns {integer} Returns the client id 
    ###
    id: ->
      @get('id')
    
    ###**
    * @ngdoc method
    * @name icalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the ical link
    *
    * @returns {string} Returns the ical link 
    ###
    icalLink: ->
      @_data.$href('ical')

    ###**
    * @ngdoc method
    * @name webcalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the web cal link
    *
    * @returns {string} Returns the web cal link
    ###
    webcalLink: ->
      @_data.$href('ical')

    ###**
    * @ngdoc method
    * @name gcalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the gcal link
    *
    * @returns {string} Returns the gcal link
    ###
    gcalLink: ->
      @_data.$href('gcal')

    ###**
    * @ngdoc method
    * @name getItems
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Get the booking items
    *
    * @returns {Promise} Returns a promise that resolve the getting items
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
    * Get the bookings promise
    *
    * @returns {Promise} Returns a promise that resolve the getting booking promise
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
    * Get the course bookings promise
    *
    * @returns {Promise} Returns a promise that resolve the getting course booking promise
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
    * Get the packages
    *
    * @returns {Promise} Returns a promise that resolve the getting packages
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
    * Get the products
    *
    * @returns {Promise} Returns a promise that resolve the getting products
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
    * Get the deals
    *
    * @returns {Promise} Returns a promise that resolve the getting deals
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
    * @param {string} booking_texts The booking texts
    * @param {array} msg_type An array with types of the messages
    * @description
    * Get the messages in according of the booking_text and msg_type parameters
    *
    * @returns {Promise} Returns a promise that resolve the getting messages
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
    * @returns {Promise} Returns a promise that resolve the getting client
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
    * @returns {Promise} Returns a promise that resolve the getting confirm messages
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
    * Print the total price of booking
    *
    * @returns {integer} Returns the total price of booking
    ###
    printed_total_price: () ->
      return "£" + parseInt(@total_price) if parseFloat(@total_price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@total_price))

    ###**
    * @ngdoc method
    * @name newPaymentUrl
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Create a new payment url
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
    * The total duration of booking
    *
    * @returns {integer} Returns the duration
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
    * Create an array what cointains wait list item
    *
    * @returns {array} Returns the wait list items 
    ###
    containsWaitlistItems: () ->
      waitlist = []
      for item in @items
        if item.on_waitlist == true
          waitlist.push(item)
      return if waitlist.length > 0 then true else false

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Static function that updated an array of total booking from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (params) ->
      PurchaseService.update(params)