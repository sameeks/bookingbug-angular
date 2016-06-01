'use strict';


###**
* @ngdoc service
* @name BB.Models:BasketItem
*
* @description
* Representation of an BasketItem Object
*
* @property {integer} company_id Company id that the basket item belongs to
* @property {integer} total_price Total price of the basket item
* @property {integer} total_due_price Total price of the basket item after applying discounts
* @property {array} items Arrays of items that are in the basket
* @property {integer} event_id The event id of the basket item
* @property {date} datetime Date and time of the event
* @property {integer} status Status of the items
*
###


angular.module('BB.Models').factory "BasketItemModel",
($q, $window, BBModel, BookableItemModel, BaseModel, $bbug, DateTimeUtilitiesService, SettingsService) ->

  # A class that defines an item in a shopping basket
  # This could represent a time based service, a ticket for an event or class, or any other purchasable item

  class BasketItem extends BaseModel

    constructor: (data, bb) ->
      super(data)
      @ready = false
      @days_link =  null
      @book_link =  null
      @parts_links = {}
      @settings or= {}
      @has_questions = false

      if bb
        @reserve_without_questions = bb.reserve_without_questions

      # if we were given an id then the item is ready - we need to fake a few items
      if @time
        @time = new BBModel.TimeSlot({time: @time, event_id: @event_id, selected: true, avail: 1, price: @price })
      if @date
        @date = new BBModel.Day({date: @date, spaces: 1})
      if @datetime
        @date = new BBModel.Day({date: @datetime.toISODate(), spaces: 1})
        cc = SettingsService.getCountryCode()
        cc = "uk" if cc != "us"
        LLLL = if cc == 'us' then "dddd, MMMM Do[,] h.mma" else "dddd Do MMMM[,] h.mma"
        moment.locale('en', {
            longDateFormat : {
                LT: "h:mm A",
                LTS: "h:mm:ss A",
                L: "MM/DD/YYYY",
                l: "M/D/YYYY",
                LL: "MMMM Do YYYY",
                ll: "MMM D YYYY",
                LLL: "MMMM Do YYYY LT",
                lll: "MMM D YYYY LT",
                LLLL: LLLL,
                llll: "ddd, MMM D YYYY LT"
            }
          })
    
        t =  @datetime.hour() * 60 +  @datetime.minute()
        @time = new BBModel.TimeSlot({time: t, event_id: @event_id, selected: true, avail: 1, price: @price })

      if @id
        @reserve_ready = true # if it has an id - it must be held - so therefore it must already be 'reservable'
        # keep a note of a possibly held item - we might change this item - but we should know waht was possibly already selected
        @held = {time: @time, date: @date, event_id: @event_id }


      @promises = []

      if data

        if data.$has("answers")
          data.$get("answers").then (answers) =>
            data.questions = []
            for a in answers
              data.questions.push({id: a.question_id, answer: a.value})

        if data.$has('company')
          comp = data.$get('company')
          @promises.push(comp)
          comp.then (comp) =>
            c = new BBModel.Company(comp)
            @promises.push(c.getSettings())
            @setCompany(c)

        if data.$has('service')
          serv = data.$get('service')
          @promises.push(serv)
          serv.then (serv) =>
            if serv.$has('category')
              prom = serv.$get('category')
              @promises.push(prom)
              prom.then (cat) =>
                @setCategory(new BBModel.Category(cat))
            @setService(new BBModel.Service(serv), data.questions)
            @setDuration(@duration) if @duration
            @checkReady()
            if @time
              @time.service = @service # the time slot sometimes wants to know thing about the service

        if data.$has('event_group')
          serv = data.$get('event_group')
          @promises.push(serv)
          serv.then (serv) =>
            if serv.$has('category')
              prom = serv.$get('category')
              @promises.push(prom)
              prom.then (cat) =>
                @setCategory(new BBModel.Category(cat))

            @setEventGroup(new BBModel.EventGroup(serv))
            if @time
              @time.service = @event_group # the time slot sometimes wants to know thing about the service

        if data.$has('event_chain')
          chain = data.$get('event_chain')
          @promises.push(chain)
          if !data.$has('event') # onlt set the event chain if we don't have the full event details - which will also set the event chain
            chain.then (serv) =>
              @setEventChain(new BBModel.EventChain(serv), data.questions)


        if data.$has('resource')
          res = data.$get('resource')
          @promises.push(res)
          res.then (res) =>
            @setResource(new BBModel.Resource(res), false)
        if data.$has('person')
          per = data.$get('person')
          @promises.push(per)
          per.then (per) =>
            @setPerson(new BBModel.Person(per), false)
        if data.$has('event')
          data.$get('event').then (event) =>
            @setEvent(new BBModel.Event(event))

        if data.settings
          @settings = $bbug.extend(true, {}, data.settings)

        if data.attachment_id
          @attachment_id = data.attachment_id

        if data.$has('product')
          data.$get('product').then (product) =>
            @setProduct(new BBModel.Product(product))

        if data.$has('package_item')
          data.$get('package_item').then (package_item) =>
            @setPackageItem(new BBModel.PackageItem(package_item))

        if data.$has('bulk_purchase')
          data.$get('bulk_purchase').then (bulk_purchase) =>
            @setBulkPurchase(new BBModel.BulkPurchase(bulk_purchase))

        if data.$has('deal')
          data.$get('deal').then (deal) =>
            @setDeal(new BBModel.Deal(deal))

        if data.$has('pre_paid_booking')
          data.$get('pre_paid_booking').then (pre_paid_booking) =>
            @setPrepaidBooking(new BBModel.PrePaidBooking(pre_paid_booking))


        @clinic_id = data.clinic_id if data.clinic_id

    ###**
    * @ngdoc method
    * @name setDefaults
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the default settings
    *
    * @returns {object} Default settings
    ###
    setDefaults: (defaults) ->
      if defaults.settings
        @settings = defaults.settings
      if defaults.company
        @setCompany(defaults.company)
      if defaults.merge_resources
        @setResource(null)
      if defaults.merge_people
        @setPerson(null)
      if defaults.resource
        @setResource(defaults.resource)
      if defaults.person
        @setPerson(defaults.person)
      if defaults.service
        @setService(defaults.service)
      if defaults.category
        @setCategory(defaults.category)
      if defaults.date
        # NOTE: date is not set as it might not be available
        defaults.date = moment(defaults.date)
      if defaults.time
         # NOTE: time is not set as it might not be available
        date = if defaults.date then defaults.date else moment()
        time = if defaults.time then parseInt(defaults.time) else 0
        defaults.datetime = DateTimeUtilitiesService.convertTimeSlotToMoment({date: defaults.date}, {time: time})
      if defaults.service_ref
        @service_ref = defaults.service_ref
      if defaults.group
        @group = defaults.group
      if defaults.clinic
        @clinic = defaults.clinic
        @clinic_id = defaults.clinic.id
      if defaults.private_note
        @private_note = defaults.private_note
      if defaults.event_group
        @setEventGroup(defaults.event_group)
      if defaults.event
        @setEvent(defaults.event)
      @defaults = defaults

    ###**
    * @ngdoc method
    * @name storeDefaults
    * @methodOf BB.Models:BasketItem
    * @description
    * Store the default settings by attaching them to the current context
    *
    * @returns {array} defaults variable
    ###
    storeDefaults: (defaults) ->
      @defaults = defaults

    ###**
    * @ngdoc method
    * @name defaultService
    * @methodOf BB.Models:BasketItem
    * @description
    * Return the default service or event group
    *
    * @returns {Object} Default Service or EventGroup
    ###
    defaultService: () ->
      if @defaults and @defaults.service
        return @defaults.service
      else if @defaults and @defaults.event_group
        return @defaults.event_group
      else
       return null



    ###**
    * @ngdoc method
    * @name setSlot
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the current slot based on the passed parameter
    *
    * @param {object} slot A hash representing a slot object
    * @returns {array} The available slot
    ###
    setSlot: (slot) ->

      @date = new BBModel.Day({date: slot.datetime.toISODate(), spaces: 1})
      t =  slot.datetime.hour() * 60 +  slot.datetime.minute()
      @time = new BBModel.TimeSlot({time: t, avail: 1, price: @price })
      @available_slot = slot.id

    ###**
    * @ngdoc method
    * @name setCompany
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the current company based on the passed parameter
    * @param {object} company a hash representing a company object
    ###
    setCompany: (company) ->
      @company = company
      @parts_links.company = @company.$href('self')
      @item_details.currency_code = @company.currency_code if @item_details

    ###**
    * @ngdoc method
    * @name clearExistingItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Clear existing item
    ###
    clearExistingItem: () ->
      if @$has('self') &&  @event_id
        prom = @$del('self')
        @promises.push(prom)
        prom.then () ->

      delete @earliest_time
      delete @event_id  # when changing the service - we ahve to clear any pre-set event

    ###**
    * @ngdoc method
    * @name setItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Set the current item based on the item object passed as parameter
    ###
    setItem: (item) ->
      return if !item
      if item.type == "person"
        @setPerson(item)
      else if item.type == "service"
        @setService(item)
      else if item.type == "resource"
        @setResource(item)

    ###**
    * @ngdoc method
    * @name setService
    * @methodOf BB.Models:BasketItem
    * @description
    * Set service in according of server parameter, if default_question is null
    *
    * @returns {array} The returned service set
    ###
    setService: (serv, default_questions = null) ->
      # if there was previously a service - reset the item details - i.e. the asnwers to questions
      if @service
        if @service.self && serv.self && @service.self == serv.self # return if it's the same service
          # make sure we reset the fact that we are using this service
          if @service.$has('book')
            @book_link = @service
          if serv.$has('days')
            @days_link = serv
          if serv.$has('book')
            @book_link = serv
          return
        # if it's a different service
        @item_details = null
        @clearExistingItem()

      if @service && serv && @service.self && serv.self
        if (@service.self != serv.self) && serv.durations && serv.durations.length > 1
          @duration = null
          @listed_duration = null

      @service = serv
      if serv && (serv instanceof BookableItemModel)
        @service = serv.item


      @parts_links.service = @service.$href('self')
      if @service.$has('book')
        @book_link = @service
      if serv.$has('days')
        @days_link = serv
      if serv.$has('book')
        @book_link = serv

      if @service.$has('questions')
        @has_questions = true

        # we have a questions link - but are there actaully any questions ?
        prom = @service.$get('questions')
        @promises.push(prom)
        prom.then (details) =>
          details.currency_code = @company.currency_code if @company
          @item_details = new BBModel.ItemDetails(details)
          @has_questions = @item_details.hasQuestions
          if default_questions
            @item_details.setAnswers(default_questions)
            @setAskedQuestions()  # make sure the item knows the questions were all answered
        , (err) =>
          @has_questions = false

      else
        @has_questions = false

      # select the first and only duration if this service only has one option

      if @service && @service.durations && @service.durations.length == 1
        @setDuration(@service.durations[0])
        @listed_duration = @service.durations[0]
      # check if the service has a listed duration (this is used for calculating the end time for display)
      if @service && @service.listed_durations && @service.listed_durations.length == 1
        @listed_duration = @service.listed_durations[0]

      if @service.$has('category')
        # we have a category?
        prom = @service.getCategoryPromise()
        if prom
          @promises.push(prom)

    ###**
    * @ngdoc method
    * @name setEventGroup
    * @methodOf BB.Models:BasketItem
    * @description
    * Set event group based on the event_group param
    *
    * @param {object} event_group a hash
    ###
    setEventGroup: (event_group) ->
      if @event_group
        if @event_group.self && event_group.self && @event_group.self == event_group.self # return if it's the same event_chain
          return

      @event_group = event_group
      @parts_links.event_group =  @event_group.$href('self').replace('event_group','service')

      if @event_group.$has('category')
        # we have a category?
        prom = @event_group.getCategoryPromise()
        if prom
          @promises.push(prom)

    ###**
    * @ngdoc method
    * @name setEventChain
    * @methodOf BB.Models:BasketItem
    * @description
    * Set event chain in according of event_chain parameter, default_qustions is null
    *
    * @returns {array} The returned set event chaint
    ###
    setEventChain: (event_chain, default_questions = null) ->
      if @event_chain
        if @event_chain.self && event_chain.self && @event_chain.self == event_chain.self # return if it's the same event_chain
          return
      @event_chain = event_chain
      @base_price = parseFloat(event_chain.price)
      if @price? and @price != @base_price
        @setPrice(@price)
      else
        @setPrice(@base_price)
      if @event_chain.isSingleBooking() # i.e. does not have tickets sets and max bookings is 1
        # if you can only book one ticket - just use that
        @tickets = {name: "Admittance", max: 1, type: "normal", price: @base_price}
        @tickets.pre_paid_booking_id = @pre_paid_booking_id
        @tickets.qty = @num_book if @num_book


      if @event_chain.$has('questions')
        @has_questions = true

        # we have a questions link - but are there actaully any questions ?
        prom = @event_chain.$get('questions')
        @promises.push(prom)
        prom.then (details) =>
          @item_details = new BBModel.ItemDetails(details)
          @has_questions = @item_details.hasQuestions
          if @questions
            for q in @item_details.questions
              a=_.find(@questions, (c) -> c.id == q.id)
              if a and q.answer is undefined or a != q.answer
                q.answer = a.answer
            @setAskedQuestions()
          if default_questions
            @item_details.setAnswers(default_questions)
            @setAskedQuestions()  # make sure the item knows the questions were all answered
        , (err) =>
          @has_questions = false
      else
        @has_questions = false

    ###**
    * @ngdoc method
    * @name setEvent
    * @methodOf BB.Models:BasketItem
    * @description
    * Set event according to event parameter
    *
    * @param {object} event A hash representing an event object
    ###
    setEvent: (event, default_questions = null) ->

      @event.unselect() if @event
      @event = event
      @event.select()
      @event_chain_id = event.event_chain_id
      @setDate({date: event.date})
      @setTime(event.time)
      @setDuration(event.duration)
      @book_link = event if event.$has('book')
      @num_book = event.qty if event.qty
      prom = @event.getChain()
      @promises.push(prom)
      prom.then (chain) =>
        @setEventChain(chain, default_questions)
      prom = @event.getGroup()
      @promises.push(prom)
      prom.then (group) =>
        @setEventGroup(group)
      if @event.getSpacesLeft() <= 0 && !@company.settings
        @status = 8 if @company.getSettings().has_waitlists
      else if @event.getSpacesLeft() <= 0 && @company.settings && @company.settings.has_waitlists
        @status = 8



    ###**
    * @ngdoc method
    * @name setCategory
    * @methodOf BB.Models:BasketItem
    * @description
    * Set category according to cat parameter
    *
    * @param {object} cat A hash representing a category object
    ###
    # if someone sets a category - we may then later restrict the service list by category
    setCategory: (cat) ->
      @category = cat

    ###**
    * @ngdoc method
    * @name setPerson
    * @methodOf BB.Models:BasketItem
    * @description
    * Set person according to per parameter
    *
    * @param {object} per A hash representing a person object

    * @param {boolean} set_selected The returned set resource for basket item
    ###
    setPerson: (per, set_selected = true) ->
      if set_selected && @earliest_time
        delete @earliest_time

      if !per
        @person = true
        @settings.person = -1 if set_selected
        @parts_links.person = null
        @setService(@service) if @service
        @setResource(@resource, false) if @resource && !@anyResource()
        if @event_id
          delete @event_id  # when changing the person - we ahve to clear any pre-set event
          @setResource(null) if @resource && @defaults && @defaults.merge_resources  # if a resources has been automatically set - clear it
      else
        @person = per
        @settings.person = @person.id if set_selected
        @parts_links.person = @person.$href('self')
        if per.$has('days')
          @days_link = per
        if per.$has('book')
          @book_link = per
        if @event_id && @$has('person') && @$href('person') != @person.self
          delete @event_id  # when changing the person - we ahve to clear any pre-set event
          @setResource(null) if @resource && @defaults && @defaults.merge_resources  # if a resources has been automatically set - clear it

    ###**
    * @ngdoc method
    * @name setResource
    * @methodOf BB.Models:BasketItem
    * @description
    * Set resource in according of res parameter, if set_selected is true
    *
    * @returns {object} The returned set resource for basket item
    ###
    setResource: (res, set_selected = true) ->
      if set_selected && @earliest_time
        delete @earliest_time

      if !res
        @resource = true
        @settings.resource = -1 if set_selected
        @parts_links.resource = null
        @setService(@service) if @service
        @setPerson(@person, false) if @person && !@anyPerson()
        if @event_id
          delete @event_id  # when changing the resource - we ahve to clear any pre-set event
          @setPerson(null) if @person && @defaults && @defaults.merge_people # if a person has been automatically set - clear it
      else
        @resource = res
        @settings.resource = @resource.id if set_selected
        @parts_links.resource = @resource.$href('self')
        if res.$has('days')
          @days_link = res
        if res.$has('book')
          @book_link = res
        if @event_id && @$has('resource') && @$href('resource') != @resource.self
          delete @event_id  # when changing the resource - we ahve to clear any pre-set event
          @setPerson(null) if @person && @defaults && @defaults.merge_people # if a person has been automatically set - clear it

    ###**
    * @ngdoc method
    * @name setDuration
    * @methodOf BB.Models:BasketItem
    * @description
    * Set duration in according of dur parameter
    *
    * @returns {integer} The returned set duration for basket item
    ###
    setDuration: (dur) ->
      @duration = dur
      if @service
        @base_price = @service.getPriceByDuration(dur)
      else if @time && @time.price
        @base_price = @time.price
      else if @price
        @base_price = @price

      @setPrice(@base_price)

    ###**
    * @ngdoc method
    * @name print_time
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print time
    *
    * @returns {date} The returned print time
    ###
    print_time: () ->
      @time.print_time() if @time

    ###**
    * @ngdoc method
    * @name print_end_time
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print end time
    *
    * @returns {date} The returned print end time
    ###
    print_end_time: () ->
      @time.print_end_time(@duration) if @time

    ###**
    * @ngdoc method
    * @name print_time12
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print time12 if show suffix is true
    *
    * @returns {date} The returned print time12
    ###
    print_time12: (show_suffix = true) ->
      @time.print_time12(show_suffix) if @time

    ###**
    * @ngdoc method
    * @name print_end_time12
    * @methodOf BB.Models:BasketItem
    * @description
    * Get to print end time12 if show_suffix is true
    *
    * @returns {date} The returned print end time12
    ###
    print_end_time12: (show_suffix = true) ->
      @time.print_end_time12(show_suffix, @duration) if @time

    ###**
    * @ngdoc method
    * @name setTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Set time in according of time parameter
    *
    * @returns {date} The returned set time
    ###
    setTime: (time) ->
      @time.unselect() if @time
      @time = time
      if @time
        @time.select()

        if @datetime
          val = parseInt(time.time)
          hours = parseInt(val / 60)
          mins = val % 60
          @datetime.hour(hours)
          @datetime.minutes(mins)

        if @price && @time.price && (@price != @time.price)
          @setPrice(@price)
        else if @price && !@time.price
         @setPrice(@price)
        else if @time.price && !@price
          @setPrice(@time.price)
        else if @price && @time.price
          @setPrice(@price)
        else
          @setPrice(null)

      @checkReady()

    ###**
    * @ngdoc method
    * @name setDate
    * @methodOf BB.Models:BasketItem
    * @description
    * Set date in according of date parameter
    *
    * @returns {date} The returned set date
    ###
    setDate: (date) ->
      @date = date
      if @date
        @date.date = moment(@date.date)
        if @datetime
          @datetime.date(@date.date.date())
          @datetime.month(@date.date.month())
          @datetime.year(@date.date.year())

      @checkReady()

    ###**
    * @ngdoc method
    * @name clearDateTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Clear date and time
    *
    * @returns {date} The returned clear date and time
    ###
    clearDateTime: () ->
      delete @date
      delete @time
      delete @datetime
      @ready = false
      @reserve_ready = false

    ###**
    * @ngdoc method
    * @name clearTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Clear time
    *
    * @returns {date} The returned clear time
    ###
    clearTime: () ->
      delete @time
      @ready = false
      @reserve_ready = false

    ###**
    * @ngdoc method
    * @name clearTime
    * @methodOf BB.Models:BasketItem
    * @description
    * Set group in according of group parameter
    *
    * @returns {object} The returned set group
    ###
    setGroup: (group) ->
      @group = group

    ###**
    * @ngdoc method
    * @name setAskedQuestions
    * @methodOf BB.Models:BasketItem
    * @description
    * Set asked questions
    *
    * @returns {object} The returned set asked questions
    ###
    setAskedQuestions: ->
      @asked_questions = true
      @checkReady()

    ###**
    * @ngdoc method
    * @name checkReady
    * @methodOf BB.Models:BasketItem
    * @description
    * Check if an item is ready for checking out
    *
    * @returns {date} The returned item has been ready for checking out
    ###
    # check if an item is ready for checking out
    # @ready - means it's fully ready for checkout
    # @reserve_ready - means the question still need asking - but it can be reserved
    checkReady: ->
      if ((@date && @time && @service) || @event || @product || @package_item || @bulk_purchase || @external_purchase || @deal || (@date && @service && @service.duration_unit == 'day')) && (@asked_questions || !@has_questions)
        @ready = true
      if ((@date && @time && @service) || @event || @product || @package_item || @bulk_purchase || @external_purchase || @deal || (@date && @service && @service.duration_unit == 'day'))  && (@asked_questions || !@has_questions || @reserve_without_questions)
        @reserve_ready = true

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:BasketItem
    * @description
    * Build an array with details for every basket item in items array
    *
    * @returns {array} Newly created details array
    ###
    getPostData: ->
      if @cloneAnswersItem
        for o_question in @cloneAnswersItem.item_details.questions
          for m_question in @item_details.questions
            if m_question.id == o_question.id
              m_question.answer = o_question.answer
              # mark questionds as asked if we're cloning
              @setAskedQuestions()

      data = {}
      if @date
        data.date = @date.date.toISODate()
      if @time
        data.time = @time.time
        if @time.event_id
          data.event_id = @time.event_id
        else if @time.event_ids # what's this about?
          data.event_ids = @time.event_ids
      else if @date and @date.event_id
        data.event_id = @date.event_id
      data.price = @price
      data.paid = @paid
      if @book_link
        data.book = @book_link.$href('book')
      data.id = @id
      data.duration = @duration
      data.settings = @settings
      data.settings ||= {}
      data.settings.earliest_time = @earliest_time if @earliest_time
      data.questions = @item_details.getPostData() if @item_details && @asked_questions
      data.move_item_id = @move_item_id if @move_item_id
      data.move_item_id = @srcBooking.id if @srcBooking
      data.service_id = @service.id if @service
      data.resource_id = @resource.id if @resource
      data.person_id = @person.id if @person
      data.length = @length
      if @event
        data.event_id = @event.id
        # when can events have a prepaid booking id?
        if @event.pre_paid_booking_id?
          data.pre_paid_booking_id = @event.pre_paid_booking_id
        else if @tickets && @tickets.pre_paid_booking_id?
          data.pre_paid_booking_id = @tickets.pre_paid_booking_id
        data.tickets = @tickets
      data.pre_paid_booking_id = @pre_paid_booking_id if @pre_paid_booking_id?
      data.event_chain_id = @event_chain_id
      data.event_group_id = @event_group_id
      data.qty = @qty
      data.status = @status if @status
      data.num_resources = parseInt(@num_resources) if @num_resources?
      data.package_id = @package_item.id if @package_item
      data.bulk_purchase_id = @bulk_purchase.id if @bulk_purchase
      data.external_purchase = @external_purchase
      data.deal = @deal if @deal
      data.recipient = @recipient if @deal && @recipient
      data.recipient_mail = @recipient_mail if @deal && @recipient && @recipient_mail
      data.coupon_id = @coupon_id
      data.is_coupon = @is_coupon
      data.attachment_id = @attachment_id if @attachment_id
      data.vouchers = @deal_codes if @deal_codes
      data.product_id = @product.id if @product

      data.email = @email if @email
      data.first_name = @first_name if @first_name
      data.last_name = @last_name if @last_name

      if @email?
        data.email = @email
      if @email_admin?
        data.email_admin = @email_admin
      data.private_note = @private_note if @private_note
      if @available_slot
        data.available_slot = @available_slot
      data.clinic_id = @clinic_id if @clinic_id
      return data

    ###**
    * @ngdoc method
    * @name setPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Set price in according of nprice parameter
    *
    * @returns {integer} The returned set price
    ###
    setPrice: (nprice) ->
      if nprice?
        @price = parseFloat(nprice)
        printed_price = @price / 100
        @printed_price = if printed_price % 1 == 0 then "£" + parseInt(printed_price) else $window.sprintf("£%.2f", printed_price)
        @printed_vat_cal = @.company.settings.payment_tax if @.company && @.company.settings
        @printed_vat = @printed_vat_cal / 100 * printed_price if @printed_vat_cal
        @printed_vat_inc = @printed_vat_cal / 100 * printed_price + printed_price if @printed_vat_cal
      else
        @price = null
        @printed_price = null
        @printed_vat_cal = null
        @printed_vat = null
        @printed_vat_inc = null

    ###**
    * @ngdoc method
    * @name getStep
    * @methodOf BB.Models:BasketItem
    * @description
    * Build a temp object with current step variables
    *
    * @returns {object} Temp hash
    ###
    getStep: ->
      temp = {}
      temp.service = @service
      temp.category = @category
      temp.person = @person
      temp.resource = @resource
      temp.duration = @duration
      temp.event = @event
      temp.event_group = @event_group
      temp.event_chain = @event_chain
      temp.time = @time
      temp.date = @date
      temp.days_link = @days_link
      temp.book_link = @book_link
      temp.ready = @ready
      return temp

    ###**
    * @ngdoc method
    * @name loadStep
    * @methodOf BB.Models:BasketItem
    * @description
    * Build current step variables based on a hash object passed as parameter
    *
    * @param {object} step Hash object representing a step
    *
    * @returns {object} The returned load step
    ###
    loadStep: (step) ->
      @service = step.service
      @category = step.category
      @person = step.person
      @resource = step.resource
      @duration = step.duration
      @event = step.event
      @event_chain = step.event_chain
      @event_group = step.event_group
      @time = step.time
      @date = step.date
      @days_link = step.days_link
      @book_link = step.book_link
      @ready = step.ready

    ###**
    * @ngdoc method
    * @name describe
    * @methodOf BB.Models:BasketItem
    * @description
    * Get information about of the basket item
    *
    * @returns {object} The returned title
    ###
    # functions for pretty printing some information about of the basket item
    describe: ->
      title = "-"
      title = @service.name if @service
      if @event_group && @event && title == "-"
        title = @event_group.name + " - " + @event.description
      title = @product.name if @product
      title = @external_purchase.name if @external_purchase
      title = @deal.name if @deal
      title = @package_item.name if @package_item
      title = @bulk_purchase.name if @bulk_purchase
      return title

    ###**
    * @ngdoc method
    * @name booking_date
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking date of the basket item, in according of format parameter
    *
    * @returns {date} The returned booking date
    ###
    booking_date: (format) ->
      return null if !@date || !@date.date
      @date.date.format(format)

    ###**
    * @ngdoc method
    * @name booking_time
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking time of the basket item in according with separator = '-'
    *
    * @returns {date} The returned booking time
    ###
    booking_time: (seperator = '-') ->
      return null if !@time
      duration = if @listed_duration then @listed_duration else @duration
      @time.print_time() + " " + seperator + " " +  @time.print_end_time(duration)

    ###**
    * @ngdoc method
    * @name duePrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Get due price for the basket item
    *
    * @returns {string} The returned price
    ###
    # prints the amount due - which might be different if it's a waitlist
    duePrice: () ->
      if @isWaitlist()
        return 0
      return @price

    ###**
    * @ngdoc method
    * @name isWaitlist
    * @methodOf BB.Models:BasketItem
    * @description
    * Checks if this is a wait list
    *
    * @returns {boolean} If this is a wait list
    ###
    isWaitlist: () ->
      return @status && @status == 8 # 8 = waitlist

    ###**
    * @ngdoc method
    * @name start_datetime
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking start date and time
    *
    * @returns {date} The returned start date time
    ###
    # get booking start datetime
    start_datetime: () ->
      return null if !@date || !@time
      start_datetime = moment(@date.date.toISODate())
      start_datetime.minutes(@time.time)
      start_datetime


    startDatetime: () ->
      @start_datetime()

    ###**
    * @ngdoc method
    * @name end_datetime
    * @methodOf BB.Models:BasketItem
    * @description
    * Get booking end date and time
    *
    * @returns {date} The returned end date time
    ###
    # get booking end datetime
    end_datetime: () ->
      return null if !@date || !@time || (!@listed_duration && !@duration)
      duration = if @listed_duration then @listed_duration else @duration
      end_datetime = moment(@date.date.toISODate())
      end_datetime.minutes(@time.time + duration)
      end_datetime


    endDatetime: () ->
      @end_datetime()

    ###**
    * @ngdoc method
    * @name setSrcBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Set a booking are to be a move if according of booking parameter
    *
    * @returns {object} The returned end date time
    ###
    # set a booking are to be a move (or a copy?) from a previous booking
    setSrcBooking: (booking) ->
      @srcBooking = booking
      # convert duration from seconds to minutes
      @duration = booking.duration

    ###**
    * @ngdoc method
    * @name anyPerson
    * @methodOf BB.Models:BasketItem
    * @description
    * Verify type of any person
    *
    * @returns {boolean} The returned any person
    ###
    anyPerson: () ->
      @person && (typeof @person == 'boolean')

    ###**
    * @ngdoc method
    * @name anyResource
    * @methodOf BB.Models:BasketItem
    * @description
    * Verify type of any resorce
    *
    * @returns {boolean} The returned any resource
    ###
    anyResource: () ->
      @resource && (typeof @resource == 'boolean')

    ###**
    * @ngdoc method
    * @name isMovingBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Verify if booking has been moved
    *
    * @returns {boolean} The returned moving booking
    ###
    isMovingBooking: ->
      (@srcBooking || @move_item_id)

    ###**
    * @ngdoc method
    * @name setCloneAnswers
    * @methodOf BB.Models:BasketItem
    * @description
    * Set clone answers in according of other item parameter
    *
    * @returns {object} The returned clone answers
    ###
    setCloneAnswers: (otherItem) ->
      @cloneAnswersItem = otherItem

    ###**
    * @ngdoc method
    * @name questionPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Question price for the basket item
    *
    * @returns {integer} The returned question price
    ###
    questionPrice: =>

      return 0 if !@item_details
      return @item_details.questionPrice(@getQty())

    ###**
    * @ngdoc method
    * @name getQty
    * @methodOf BB.Models:BasketItem
    * @description
    * Get quantity of tickets
    *
    * @returns {integer} The returned quatity of tickets
    ###
    getQty: =>
      return @qty if @qty
      return @tickets.qty if @tickets
      return 1

    ###**
    * @ngdoc method
    * @name totalPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Total price of the basket item (price including discounts)
    *
    * @returns {integer} The returned total price
    ###
    # price including discounts
    totalPrice: =>
      if @tickets && @tickets.pre_paid_booking_id
        return 0
      if @pre_paid_booking_id
        return 0
      if @discount_price?
        return @discount_price + @questionPrice()
      pr = @total_price
      pr = @price if !angular.isNumber(pr)
      pr = 0      if !angular.isNumber(pr)
      return pr + @questionPrice()

    ###**
    * @ngdoc method
    * @name fullPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Full price for the basket item (price not including discounts)
    *
    * @returns {integer} The returned full price
    ###
    # price excluding discounts
    fullPrice: =>
      pr = @base_price
      pr ||= @total_price
      pr ||= @price
      pr ||= 0
      return pr + @questionPrice()

    ###**
    * @ngdoc method
    * @name setProduct
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a product to the BasketItem
    *
    ###
    setProduct: (product) ->
      @product = product
      @book_link = @product if @product.$has('book')
      @setPrice(product.price) if product.price


    ###**
    * @ngdoc method
    * @name setPackageItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a package to the BasketItem
    *
    ###
    setPackageItem: (package_item) ->
      @package_item = package_item
      @book_link = @package_item if @package_item.$has('book')
      @setPrice(package_item.price) if package_item.price


    ###**
    * @ngdoc method
    * @name setBulkPurchase
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a bulk purchase to the BasketItem
    *
    ###
    setBulkPurchase: (bulk_purchase) ->
      @bulk_purchase = bulk_purchase
      @book_link = @bulk_purchase if @bulk_purchase.$has('book')
      @setPrice(bulk_purchase.price) if bulk_purchase.price

    ###**
    * @ngdoc method
    * @name setExternalPurchase
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply an external purchase to the BasketItem
    *
    ###
    setExternalPurchase: (external_purchase) ->
      @external_purchase = external_purchase
      @book_link = @company
      @setPrice(external_purchase.price) if external_purchase.price

    ###**
    * @ngdoc method
    * @name setDeal
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a deal on to BasketItem
    *
    ###
    setDeal: (deal) ->
      @deal = deal
      @book_link = @deal if @deal.$has('book')
      @setPrice(deal.price) if deal.price


    ###**
    * @ngdoc method
    * @name hasPrice
    * @methodOf BB.Models:BasketItem
    * @description
    * Checks if the BasketItem has a price
    *
    * @returns {boolean}
    ###
    hasPrice: () ->
      return @price?


    ###**
    * @ngdoc method
    * @name getAttachment
    * @methodOf BB.Models:BasketItem
    * @description
    * Get attachment of the basket item
    *
    * @returns {object} The attachment
    ###
    getAttachment: () ->
      return @attachment if @attachment
      if @$has('attachment') && @attachment_id
        @_data.$get('attachment').then (att) =>
          @attachment = att
          @attachment


    ###**
    * @ngdoc method
    * @name setPrepaidBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Apply a prepaid booking to BasketItem
    *
    ###
    setPrepaidBooking: (pre_paid_booking) ->
      @pre_paid_booking    = pre_paid_booking
      @pre_paid_booking_id = pre_paid_booking.id


    ###**
    * @ngdoc method
    * @name hasPrepaidBooking
    * @methodOf BB.Models:BasketItem
    * @description
    * Indicates if the basket item has a prepaid booking applied
    *
    * @returns {boolean} boolean indicating if the BasketItem has a prepaid booking
    ###
    hasPrepaidBooking: () ->
      return @pre_paid_booking_id?


    ###**
    * @ngdoc method
    * @name getEventId
    * @methodOf BB.Models:BasketItem
    * @description
    * Get the event id for the BasketItem
    *
    * @returns {string} The Event ID
    ###
    getEventId: () ->
      if @time and @time.event_id
        return @time.event_id
      else if @date and @date.event_id
        return @date.event_id
      else if @event
        return @event.id


    ###**
    * @ngdoc method
    * @name isExternalPurchase
    * @methodOf BB.Models:BasketItem
    * @description
    * Indicates if the BasketItem is an external purchase
    *
    * @returns {boolean}
    ###
    isExternalPurchase: () ->
      return @external_purchase?


    ###**
    * @ngdoc method
    * @name getName
    * @methodOf BB.Models:BasketItem
    * @description
    * Returns the name
    *
    * @returns {String}
    ###
    getName: (client) ->
      if @first_name
        return "#{@first_name} #{@last_name}"
      else if client
        return client.getName()


    ###**
    * @ngdoc method
    * @name isTimeItem
    * @methodOf BB.Models:BasketItem
    * @description
    * Indicates if the BasketItem is a time item (i.e. either an event
    * or appointment booking)
    *
    * @returns {boolean}
    ###
    isTimeItem: () ->
      return @service or @event
