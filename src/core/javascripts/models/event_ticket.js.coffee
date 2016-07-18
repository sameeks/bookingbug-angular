'use strict';


###**
* @ngdoc service
* @name BB.Models:EventTicket
*
* @description
* Representation of an EventTicket Object
*
* @property {integer} max The maximum of the event ticket
* @property {integer} max_num_bookings The maximum number of the bookings
* @property {integer} max_spaces The maximum spaces of the evenet
* @property {integer} counts_as The counts as
* @property {string} pool_name The pool name
* @property {string} name The name 
* @property {string} min_num_bookings The minimum number of the bookings
* @property {string} qty The quantity of the event ticket
* @property {string} totalQty The total quantity of the event ticket
####


angular.module('BB.Models').factory "EventTicketModel", ($q, BBModel, BaseModel) ->

  class EventTicket extends BaseModel


    constructor: (data) ->
      super(data)

      @max = @max_num_bookings

      # max_spaces is the total number of spaces reported by the event chain
      # adjust max if total spaces is less than max_num_bookings
      if @max_spaces
        ms = @max_spaces
        # count_as defines the number of spaces a ticket uses
        ms = @max_spaces / @counts_as if @counts_as
        if ms < max
          @max = ms


    ###**
    * @ngdoc method
    * @name fullName
    * @methodOf BB.Models:EventTicket
    * @description
    * Get the full name
    *
    * @returns {object} The returned full name
    ###
    fullName: () ->
      if @pool_name
        return @pool_name + " - " + @name
      @name


    ###**
    * @ngdoc method
    * @name getRange
    * @methodOf BB.Models:EventTicket
    * @description
    * Get the range between minimum number of bookings and the maximum number of bookings
    *
    * @returns {array} The returned range
    ###
    getRange: (event, cap) ->

      return if !event

      # if not simple ticket, pass pool id to event methods
      pool = null
      pool = @pool_id if @ticket_set

      max = @getMax(event, pool, cap)
      min = if max <= @min_num_bookings then max else @min_num_bookings

      [].concat [min..max]


    ###**
    * @ngdoc method
    * @name getMax
    * @methodOf BB.Models:EventTicket
    * @description
    * Get the maximum - this looks at an optional cap, the maximum available and potential a running count of tickets already selected (from passing in the event being booked)
    *
    * @returns {Integer} The max number of tickets that can be selected
    ###
    getMax: (ev, pool = null, cap = null) ->

      isAvailable = (event) ->
        _.each event.ticket_spaces, (ts) ->
          return false if ts.left <= 0
        return true

      return 0 if !ev

      # only show wait spaces if no spaces available in any pool
      if !isAvailable(ev) or ev.getSpacesLeft() <= 0
        spaces_left = ev.getWaitSpacesLeft()
        wait_spaces = true
      else
        spaces_left = ev.getSpacesLeft(pool)

      live_max = if spaces_left <= @max then spaces_left else @max

      used = 0

      # count number of spaces used across the same ticket pool (except when spaces_left are waitlist ones)
      for ticket in ev.tickets
        used += ticket.totalQty() if ticket.pool_id is @pool_id or wait_spaces
      
      # subtract self from used space count
      if @qty
        used = used - @totalQty()

      # adjust number of spaces used by count_as
      if @counts_as
        used = Math.ceil(used/@counts_as)

      live_max = live_max - used
      live_max = 0 if live_max < 0

      left = left - used
      left = 0 if left < 0

      # use ticket cap if set
      cap = @cap if @cap

      if !cap || cap > left
        cap = left   

      # adjust max by cap if it's lower
      if cap
        c = cap
        c = cap / @counts_as if @counts_as
        if c < live_max
          return c

      return live_max


    ###**
    * @ngdoc method
    * @name totalQty
    * @methodOf BB.Models:EventTicket
    * @description
    * Get the total quantity of the event ticket
    *
    * @returns {array} The returned total quantity
    ###
    totalQty: () ->
      return 0 if !@qty
      return @qty if !@counts_as  
      return @qty * @counts_as


    ###**
    * @ngdoc method
    * @name add
    * @methodOf BB.Models:EventTicket
    * @description
    * Add to the a quantity a new value
    *
    * @returns {array} The returned new quantity added
    ###
    add: (value) ->
      @qty = 0 if !@qty
      @qty = parseInt(@qty)
      
      return if angular.isNumber(@qty) and (@qty >= @max and value > 0) or (@qty is 0 and value < 0)
      @qty += value


    ###**
    * @ngdoc method
    * @name subtract
    * @methodOf BB.Models:EventTicket
    * @description
    * Subtract a value from the quantity
    *
    * @returns {array} The returned substract
    ###
    subtract: (value) ->
      @add(-value)

