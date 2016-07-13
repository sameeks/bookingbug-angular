###**
* @ngdoc service
* @name BB.Models:Event
*
* @description
* This is the event object returned by the API
*
* @property {integer} id The event id
* @property {date} datetime The event date and time
* @property {string} description Description of the event
* @property {integer} status Status of the event
* @property {integer} spaces_booked The booked spaces
* @property {integer} duration Duration of the event
####


angular.module('BB.Models').factory "EventModel", ($q, BBModel, BaseModel,
  DateTimeUtilitiesService, EventService) ->


  class Event extends BaseModel

    constructor: (data) ->
      super(data)
      @date = moment.parseZone(@datetime)
      @time = new BBModel.TimeSlot(time: DateTimeUtilitiesService.convertMomentToTime(@date))
      @end_datetime = @date.clone().add(@duration, 'minutes') if @duration
      @date_unix = @date.unix()

    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:Event
    * @description
    * Get event groups
    *
    * @returns {promise} A promise for the group event
    ###
    getGroup: () ->
      defer = $q.defer()
      if @group
        defer.resolve(@group)
      else if @$has('event_groups') or @$has('event_group')
        event_group = 'event_group'
        event_group = 'event_groups' if @$has('event_groups')
        @$get(event_group).then (group) =>
          @group = new BBModel.EventGroup(group)
          defer.resolve(@group)
        , (err) ->
          defer.reject(err)
      else
        defer.reject("No event group")
      defer.promise

    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:Event
    * @description
    * Get the chains of the event
    *
    * @returns {promise} A promise for the chains event
    ###
    getChain: () ->
      defer = $q.defer()
      if @chain
        defer.resolve(@chain)
      else
        if @$has('event_chains') or @$has('event_chain')
          event_chain = 'event_chain'
          event_chain = 'event_chains' if @$has('event_chains')
          @$get(event_chain).then (chain) =>
            @chain = new BBModel.EventChain(chain)
            defer.resolve(@chain)
        else
          defer.reject("No event chain")
      defer.promise

    ###**
    * @ngdoc method
    * @name getDuration
    * @methodOf BB.Models:Event
    * @description
    * Get duration of the event chains
    *
    * @returns {promise} A promise for duration of the event
    ###
    getDuration: () ->
      defer = new $q.defer()
      if @duration
        defer.resolve(@duration)
      else
        @getChain().then (chain) =>
          @duration = chain.duration
          defer.resolve(@duration)
      defer.promise


    ###**
    * @ngdoc method
    * @name getDescription
    * @methodOf BB.Models:Event
    * @description
    * Get duration of the event
    *
    * @returns {object} The returned description
    ###
    getDescription: () ->
      @getChain().description

    ###**
    * @ngdoc method
    * @name getColour
    * @methodOf BB.Models:Event
    * @description
    * Get the colour
    *
    * @returns {string} The returned colour
    ###
    getColour: () ->
      if @getGroup()
        return @getGroup().colour
      else
        return "#FFFFFF"


    ###**
    * @ngdoc method
    * @name getPounds
    * @methodOf BB.Models:Event
    * @description
    * Get pounts
    *
    * @returns {integer} The returned pounts
    ###
    getPounds: () ->
      if @chain
        Math.floor(@getPrice()).toFixed(0)

    ###**
    * @ngdoc method
    * @name getPrice
    * @methodOf BB.Models:Event
    * @description
    * Get price
    *
    * @returns {integer} The returned price
    ###
    getPrice: () ->
      0

    ###**
    * @ngdoc method
    * @name getPence
    * @methodOf BB.Models:Event
    * @description
    * Get price
    *
    * @returns {integer} The returned pence
    ###
    getPence: () ->
      if @chain
        (@getPrice() % 1).toFixed(2)[-2..-1]

    ###**
    * @ngdoc method
    * @name getNumBooked
    * @methodOf BB.Models:Event
    * @description
    * Get the number booked
    *
    * @returns {object} The returned number booked
    ###
    getNumBooked: () ->
      @spaces_blocked + @spaces_booked + @spaces_reserved + @spaces_held

    ###**
    * @ngdoc method
    * @name getSpacesLeft
    * @methodOf BB.Models:Event
    * @description
    * Get the number of spaces left (possibly limited by a specific ticket pool)
    *
    * @returns {object} The returned spaces left
    ###
    getSpacesLeft: (pool = null) ->
      if pool && @ticket_spaces && @ticket_spaces[pool]
        return @ticket_spaces[pool].left
      else
        x =  @num_spaces - @getNumBooked()
        return 0 if x < 0
        return x


    ###**
    * @ngdoc method
    * @name getWaitSpacesLeft
    * @methodOf BB.Models:Event
    * @description
    * Get the number of waitlist spaces left (possibly limited by a specific ticket pool)
    *
    * @returns {object} The returned spaces left
    ###
    getWaitSpacesLeft: (pool = null) ->
      wait = @getChain().waitlength
      wait ||= 0
      wait = wait - @spaces_wait
      return 0 if wait <= 0

      if pool && @ticket_spaces && @ticket_spaces[pool]
        pool_left =  @ticket_spaces[pool].left
        return pool_left if wait > pool_left # use the pool if the pool has left that the wait list allowance
      return wait

    ###**
    * @ngdoc method
    * @name hasSpace
    * @methodOf BB.Models:Event
    * @description
    * Checks if this considered a valid space
    *
    * @returns {boolean} If this is a valid space
    ###
    hasSpace: () ->
      (@getSpacesLeft() > 0)

    ###**
    * @ngdoc method
    * @name hasWaitlistSpace
    * @methodOf BB.Models:Event
    * @description
    * Checks if this considered a valid waiting list space
    *
    * @returns {boolean} If this is a valid waiting list space
    ###
    hasWaitlistSpace: () ->
      (@getSpacesLeft() <= 0 && @getChain().waitlength > @spaces_wait)

    ###**
    * @ngdoc method
    * @name getRemainingDescription
    * @methodOf BB.Models:Event
    * @description
    * Get the remaining description
    *
    * @returns {object} The returned remaining description
    ###
    getRemainingDescription: () ->
      left = @getSpacesLeft()
      if left > 0 && left < 3
        return "Only " + left + " " + (if left > 1 then "spaces" else "space") + " left"
      if @hasWaitlistSpace()
        return "Join Waitlist"
      return ""

    ###**
    * @ngdoc method
    * @name select
    * @methodOf BB.Models:Event
    * @description
    * Checks is this considered a selected
    *
    * @returns {boolean} If this is a selected
    ###
    select: ->
      @selected = true


    ###**
    * @ngdoc method
    * @name unselect
    * @methodOf BB.Models:Event
    * @description
    * Unselect if is selected
    *
    * @returns {boolean} If this is a unselected
    ###
    unselect: ->
      delete @selected if @selected

    ###**
    * @ngdoc method
    * @name prepEvent
    * @methodOf BB.Models:Event
    * @description
    * Prepare the event
    *
    * @returns {promise} A promise for the event
    ###
    prepEvent: () ->
      # build out some useful event stuff
      def = $q.defer()
      @getChain().then () =>

        if @chain.$has('address')
          @chain.$getAddress().then (address) =>
            @chain.address = address

        @chain.getTickets().then (tickets) =>
          @tickets = tickets

          @price_range = {}
          if tickets and tickets.length > 0
            for ticket in @tickets
              @price_range.from = ticket.price if !@price_range.from or (@price_range.from and ticket.price < @price_range.from)
              @price_range.to = ticket.price if !@price_range.to or (@price_range.to and ticket.price > @price_range.to)
              ticket.old_price = ticket.price
          else
            @price_range.from  = @price
            @price_range.to = @price

          @ticket_prices = _.indexBy(tickets, 'name')

          def.resolve(@)
      def.promise

    ###**
    * @ngdoc method
    * @name updatePrice
    * @methodOf BB.Models:Event
    * @description
    * Update price for the ticket
    *
    * @returns {object} The returned update price
    ###
    updatePrice: () ->
      for ticket in @tickets
        if ticket.pre_paid_booking_id
          ticket.price = 0
        else
          ticket.price = ticket.old_price

    @$query: (company, params) ->
      EventService.query(company, params)

    @$summary: (company, params) ->
      EventService.summary(company, params)

    ###**
    * @ngdoc method
    * @name numTicketsSelected
    * @methodOf BB.Models:Event
    * @description
    *
    *
    * @returns {object} get number of tickets selected
    ###
    numTicketsSelected: () ->
      num = 0
      for ticket in @tickets
        num += ticket.qty
      num

