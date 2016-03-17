'use strict';

###**
* @ngdoc service
* @name BB.Models:EventChain
*
* @description
* Representation of an EventChain Object
*
* @property {number} id Event chain id
* @property {string} name Event chain name
* @property {string} description Event chain description
* @property {number} capacity_view Event chain capacity view
* @property {date} start_date Event chain start date
* @property {date} finish_date Event chain finish date
* @property {number} price Event chain price
* @property {string} ticket_type Tcket tpye
* @property {boolean} course Verifies if the course exist or not
####

angular.module('BB.Models').factory "EventChainModel", ($q, BBModel, BaseModel, EventChainService) ->

  class EventChain extends BaseModel
    name: () ->
      @_data.name

    ###**
    * @ngdoc method
    * @name isSingleBooking
    * @methodOf BB.Models:EventChain
    * @description
    * Verifies if is a single booking.
    *
    * @returns {boolean} True if event allows only one booking and has no more tickets sets
    ###
    isSingleBooking: () ->
      return @max_num_bookings == 1 && !@$has('ticket_sets')

    ###**
    * @ngdoc method
    * @name hasTickets
    * @methodOf BB.Models:EventChain
    * @description
    * Checks if the tickets are valid.
    *
    * @returns {boolean} True if it has an ticket sets
    ###
    hasTickets: () ->
      @$has('ticket_sets')

    ###**
    * @ngdoc method
    * @name getTickets
    * @methodOf BB.Models:EventChain
    * @description
    * Gets the tickets for the event chain.
    *
    * @returns {promise} A promise for the tickets
    ###
    getTickets: () ->
      def = $q.defer()
      if @tickets
        def.resolve(@tickets)
      else
        if @$has('ticket_sets')
          @$get('ticket_sets').then (tickets) =>
            @tickets = []
            for ticket in tickets
              @tickets.push(new BBModel.EventTicket(ticket))
            @adjustTicketsForRemaining()
            def.resolve(@tickets)
        else
          @tickets = [new BBModel.EventTicket(
            name: "Admittance"
            min_num_bookings: 1
            max_num_bookings: @max_num_bookings
            type: "normal"
            price: @price
          )]
          @adjustTicketsForRemaining()
          def.resolve(@tickets)
      return def.promise

    ###**
    * @ngdoc method
    * @name adjustTicketsForRemaining
    * @methodOf BB.Models:EventChain
    * @description
    * Adjust the number of tickets that can be booked due to changes in the number of remaining spaces for each ticket set.
    *
    * @returns {object} The returned adjust tickets for remaining
    ###
    adjustTicketsForRemaining: () ->
      if @tickets
        for @ticket in @tickets
          @ticket.max_spaces = @spaces

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:EventChain
    * @description
    * Static function that loads an array of event chains from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company, params) ->
      EventChainService.query(company, params)
