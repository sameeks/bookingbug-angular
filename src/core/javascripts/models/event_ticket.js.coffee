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

      if @max_spaces
        ms = @max_spaces
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
    getRange: (cap) ->
      if cap
        c = cap
        c = cap / @counts_as if @counts_as
        if c + @min_num_bookings < @max
          @max = c + @min_num_bookings

      [0].concat [@min_num_bookings..@max]

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
    * @name getMax
    * @methodOf BB.Models:EventTicket
    * @description
    * Get the maximum - this looks at an optional cap, the maximum available and potential a running count of tickest already selected (from passing in the event being booked)
    *
    * @returns {array} The returned maximum
    ###
    # get the max - this looks at an optional cap, the maximum available and potential a running count of tickest already selected (from passing in the event being booked)
    getMax: (cap, ev = null) ->
      live_max = @max
      if ev
        used = 0
        for ticket in ev.tickets
          used += ticket.totalQty()
        if @qty
          used = used - @totalQty()
        if @counts_as
          used = Math.ceil(used/@counts_as)

        live_max = live_max - used
        live_max = 0 if live_max < 0
      if cap
        c = cap
        c = cap / @counts_as if @counts_as
        if c + @min_num_bookings < live_max
          return c + @min_num_bookings
      return live_max

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

