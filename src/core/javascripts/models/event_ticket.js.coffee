'use strict';

###**
* @ngdoc service
* @name BB.Models:EventTicket
*
* @description
* Representation of an EventTicket Object
*
* @property {number} max The maximum number of tickets for the event
* @property {number} max_num_bookings The maximum number of bookings
* @property {number} max_spaces The maximum spaces of the evenet
* @property {number} counts_as Counts as
* @property {string} pool_name Pool name
* @property {string} name Name
* @property {string} min_num_bookings Minimum number of bookings
* @property {string} qty The quantity of the event ticket
* @property {string} totalQty Total quantity of the event tickets
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
    * Gets the event ticket full name.
    *
    * @returns {object} Full name
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
    * Gets the range between minimum and maximum number of bookings.
    *
    * @param {number} cap cap parameter
    * @returns {array} Range
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
    * Gets the total quantity of the event tickets.
    *
    * @returns {number} Rotal Tickets quantity
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
    * Gets the maximum - this looks at an optional cap, the maximum available and potential a running count of tickest already selected (from passing in the event being booked)
    *
    * @returns {number} Maximum
    ###
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
    * Adds a new value to the a quantity.
    *
    * @returns {number} New quantity
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
    * Subtracts a value from the quantity.
    *
    * @returns {number} New quantity
    ###
    subtract: (value) ->
      @add(-value)

