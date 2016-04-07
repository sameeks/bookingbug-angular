'use strict';

###**
* @ngdoc service
* @name BB.Models:PurchaseTotal
*
* @description
* Representation of an Purchase Total Object
*
* @property {number} total_price The total price of booking
* @property {number} price Booking price
* @propertu {number} paid The booking paid
####

angular.module('BB.Models').factory "Purchase.TotalModel", ($q, $window, BBModel, BaseModel, $sce, PurchaseService) ->

  class Purchase_Total extends BaseModel
    constructor: (data) ->
      super(data)
      @getItems().then (items) =>
        @items = items
      @getClient().then (client) =>
        @client = client
      @getMember().then (member) =>
        @member = member

    ###**
    * @ngdoc method
    * @name id
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Gets the client id.
    *
    * @returns {number} Returns the client id
    ###
    id: ->
      @get('id')

    ###**
    * @ngdoc method
    * @name icalLink
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Gets the ical link.
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
    * Gets the web cal link.
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
    * Gets the gcal link.
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
    * Gets the booking items.
    *
    * @returns {Promise} A promise that on success will return the items
    ###
    getItems: =>
      defer = $q.defer()
      defer.resolve(@items) if @items
      $q.all([
        @$getBookings(),
        @$getCourseBookings(),
        @getPackages(),
        @getProducts(),
        @getDeals()
      ]).then (result) ->
        items = _.flatten(result)
        defer.resolve(items)
      defer.promise

    ###**
    * @ngdoc method
    * @name getBookings
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Gets the bookings.
    *
    * @returns {Promise} Returns a promise that on success will return an array of bookings
    ###
    $getBookings: =>
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
    * @name getCourseBookings
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Gets the course bookings.
    *
    * @returns {Promise} A promise that on success will return the course bookings
    ###
    $getCourseBookings: =>
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
    * Gets the packages.
    *
    * @returns {Promise} A promise that on success will return the packages
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
    * Gets the products.
    *
    * @returns {Promise} A promise that on success will return the products
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
    * Gets the deals.
    *
    * @returns {Promise} A promise that on success will return the deals
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
    * @description
    * Gets the messages.
    *
    * @param {array} booking_texts booking_texts parameter
    * @param {array} msg_type msg_type parameter
    *
    * @returns {Promise} A promise that on success will return an array of messages
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
    * Gets the client.
    *
    * @returns {Promise} A promise that on success will return an client object
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
    * Gets the member.
    *
    * @returns {Promise} A promise that on success will return an member object
    ###
    getMember: =>
      defer = $q.defer()
      if @_data.$has('member')
        @_data.$get('member').then (member) =>
          @member = new BBModel.Client(member)
          defer.resolve(@member)
      else
        defer.reject('No member')
      defer.promise

    ###**
    * @ngdoc method
    * @name getConfirmMessages
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Gets the confirm messages.
    *
    * @returns {Promise} A promise that on success will return the confirm messages
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
    * Prints the booking total price.
    *
    * @returns {number} Returns the total booking price
    ###
    printed_total_price: () ->
      return "£" + parseInt(@total_price) if parseFloat(@total_price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@total_price))

    ###**
    * @ngdoc method
    * @name newPaymentUrl
    * @methodOf BB.Models:PurchaseTotal
    * @description
    * Creates a new payment url.
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
    * Gets the booking total duration.
    *
    * @returns {number} Total duration
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
    * Creates an array that cointains the wait list items.
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
    * Static function that loads the total purchase object.
    *
    * @param {object} params params
    *
    * @returns {promise} A promise that on success will return an array of total bookings
    ###
    @$query: (params) ->
      PurchaseService.update(params)
