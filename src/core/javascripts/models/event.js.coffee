###**
* @ngdoc service
* @name BB.Models:Event
*
* @description
* This is the event object returned by the API
*
* @property {number} id Event id
* @property {date} datetime Event date and time
* @property {string} description Event description
* @property {number} status Event status
* @property {number} spaces_booked Booked spaces
* @property {number} duration Event duration
####

angular.module('BB.Models').factory "EventModel", ($q, BBModel, BaseModel, DateTimeUlititiesService, EventService) ->


  class Event extends BaseModel

    constructor: (data) ->
      super(data)
      @date = moment.parseZone(@datetime)
      @time = new BBModel.TimeSlot(time: DateTimeUlititiesService.convertMomentToTime(@date))
      @end_datetime = @date.clone().add(@duration, 'minutes') if @duration
      @date_unix = @date.unix()

    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:Event
    * @description
    * Gets the event group.
    *
    * @returns {promise} A promise that on success will return the event group object
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
    * @name getChain
    * @methodOf BB.Models:Event
    * @description
    * Gets the event chain.
    *
    * @returns {promise} A promise that on success will return the event chain object
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
    * @name getDate
    * @methodOf BB.Models:Event
    * @description
    * Gets the event date.
    *
    * @returns {date} Event date
    ###
    getDate: () ->
      return @date if @date
      @date = moment(@_data.datetime)
      return @date

    ###**
    * @ngdoc method
    * @name dateString
    * @methodOf BB.Models:Event
    * @description
    * Gets the event date in string format.
    *
    * @param {string} str str parameter
    *
    * @returns {string} Event date
    ###
    dateString: (str) ->
      date = @date()
      if date then date.format(str)

    ###**
    * @ngdoc method
    * @name getDuration
    * @methodOf BB.Models:Event
    * @description
    * Gets the event chain duration.
    *
    * @returns {promise} A promise that on success will return the event chain duration
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
    * @name printDuration
    * @methodOf BB.Models:Event
    * @description
    * Displays the event duration.
    *
    * @returns {string} Event duration
    ###
    printDuration: () ->
      if @duration < 60
        @duration + " mins"
      else
        h = Math.round(@duration / 60)
        m = @duration % 60
        if m == 0
          h + " hours"
        else
          h + " hours " + m + " mins"

    ###**
    * @ngdoc method
    * @name getDescription
    * @methodOf BB.Models:Event
    * @description
    * Gets the event description.
    *
    * @returns {string} Event description
    ###
    getDescription: () ->
      @getChain().description

    ###**
    * @ngdoc method
    * @name getColour
    * @methodOf BB.Models:Event
    * @description
    * Gets the event color.
    *
    * @returns {string} The returned color
    ###
    getColour: () ->
      if @getGroup()
        return @getGroup().colour
      else
        return "#FFFFFF"

    ###**
    * @ngdoc method
    * @name getPerson
    * @methodOf BB.Models:Event
    * @description
    * Gets the person assigned to the event.
    *
    * @returns {string} Person name
    ###
    getPerson: () ->
      @getChain().person_name

    ###**
    * @ngdoc method
    * @name getPounds
    * @methodOf BB.Models:Event
    * @description
    * Gets the price in pounds.
    *
    * @returns {number} Price
    ###
    getPounds: () ->
      if @chain
        Math.floor(@getPrice()).toFixed(0)

    ###**
    * @ngdoc method
    * @name getPrice
    * @methodOf BB.Models:Event
    * @description
    * Gets the  price.
    *
    * @returns {number} The returned price
    ###
    getPrice: () ->
      0

    ###**
    * @ngdoc method
    * @name getPence
    * @methodOf BB.Models:Event
    * @description
    * Gets the price in pence.
    *
    * @returns {number} Price
    ###
    getPence: () ->
      if @chain
        (@getPrice() % 1).toFixed(2)[-2..-1]

    ###**
    * @ngdoc method
    * @name getNumBooked
    * @methodOf BB.Models:Event
    * @description
    * Gets the number booked.
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
    * Gets the number of spaces left (possibly limited by a specific ticket pool).
    *
    * @returns {number} Spaces left
    ###
    # get the number of spaces left (possibly limited by a specific ticket pool)
    getSpacesLeft: (pool = null) ->
      if pool && @ticket_spaces && @ticket_spaces[pool]
        return @ticket_spaces[pool].left
      return @num_spaces - @getNumBooked()

    ###**
    * @ngdoc method
    * @name hasSpace
    * @methodOf BB.Models:Event
    * @description
    * Checks if this is considered a valid space.
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
    * Checks if this is considered a valid waiting list space.
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
    * Gets the remaining description.
    *
    * @returns {object} Remaining description
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
    * Sets selected flag to true if an event is selected.
    *
    * @returns {boolean} True
    ###
    select: ->
      @selected = true


    ###**
    * @ngdoc method
    * @name unselect
    * @methodOf BB.Models:Event
    * @description
    * Unselect the event if is selected.
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
    * Prepares  the event by building some useful information about the event.
    *
    * @returns {promise} A promise for the event
    ###
    prepEvent: () ->
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
    * Updates the ticket price.
    *
    * @returns {object} Updated price
    ###
    updatePrice: () ->
      for ticket in @tickets
        if ticket.pre_paid_booking_id
          ticket.price = 0
        else
          ticket.price = ticket.old_price

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Event
    * @description
    * Static function that loads an array of events from a company object.
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company, params) ->
      EventService.query(company, params)

    @$summary: (company, params) ->
      EventService.summary(company, params)

