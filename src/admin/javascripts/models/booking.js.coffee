'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminBooking
*
* @description
* Representation of an Booking Object
*
* @property {integer} company_id The company id
* @property {date} datetime Booking date and time
* @property {date} start Booking start date
* @property {date} end Booking end date
* @property {string} title The title of the booking
* @property {integer} time Booking time
* @property {boolean} allDay Booking availability of the day
* @property {integer} status The status of the booking
####


angular.module('BB.Models').factory "Admin.BookingModel", ($q, BBModel, BaseModel, BookingCollections) ->

  class Admin_Booking extends BaseModel

    constructor: (data) ->
      super
      @datetime = moment(@datetime)
      @start = @datetime
      @end = @datetime.clone().add(@duration, 'minutes')
      @title = @full_describe
      @time = @start.hour()* 60 + @start.minute()
      @allDay = false
      if @status == 3
        @className = "status_blocked"
      else if @status == 4
        @className = "status_booked"
 
    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminBooking
    * @description
    * Get post data
    *
    * @returns {array} Returns data
    ###
    getPostData: () ->
      data = {}
      data.date = @start.format("YYYY-MM-DD")
      data.time = @start.hour() * 60 + @start.minute()
      data.duration = @duration
      data.id = @id
      data.person_id = @person_id
      if @questions
        data.questions = (q.getPostData() for q in @questions)
      data
      
    ###**
    * @ngdoc method
    * @name hasStatus
    * @methodOf BB.Models:AdminBooking
    * @param {boolean=} status The status of the booking
    * @description
    * Verify if booking have status true or false
    *
    * @returns {boolean} Returns the status value
    ###
    hasStatus: (status) ->
      @multi_status[status]?

    ###**
    * @ngdoc method
    * @name statusTime
    * @methodOf BB.Models:AdminBooking
    * @param {boolean} status The status of the booking
    * @description
    * Verify the status time
    *
    * @returns {string} Returns the status time
    ###
    statusTime: (status) ->
      if @multi_status[status]
        moment(@multi_status[status])
      else
        null

    ###**
    * @ngdoc method
    * @name sinceStatus
    * @methodOf BB.Models:AdminBooking
    * @param {boolean} status The status of the booking
    * @description
    * Verify the status time in according of the status parameter
    *
    * @returns {integer} Returns 0 if status time is null or the moment status
    ###
    sinceStatus: (status) ->
      s = @statusTime(status)
      return 0 if !s
      return Math.floor((moment().unix() - s.unix()) / 60)

    ###**
    * @ngdoc method
    * @name sinceStart
    * @methodOf BB.Models:AdminBooking
    * @param {object} options The options of the booking
    * @description
    * Get the start time of the booking in according of the option parameter
    *
    * @returns {integer} Returns the start of booking
    ###
    sinceStart: (options) ->
      start = @datetime.unix()
      if !options
        return Math.floor((moment().unix() - start) / 60)
      if options.later
        s = @statusTime(options.later).unix()
        if s > start
          return Math.floor((moment().unix() - s) / 60)
      if options.earlier
        s = @statusTime(options.earlier).unix()
        if s < start
          return Math.floor((moment().unix() - s) / 60)
      return Math.floor((moment().unix() - start) / 60)

    ###**
    * @ngdoc method
    * @name answer
    * @methodOf BB.Models:AdminBooking
    * @param {string=} q The question of the answer
    * @description
    * Get the answer in according of the q parameter
    *
    * @returns {string} Returns the answer
    ###
    answer: (q) ->
      if @answers_summary
        for a in @answers_summary
          if a.name == q
            return a.answer
      return null
 

    ###**
    * @ngdoc method
    * @name update
    * @methodOf BB.Models:AdminBooking
    * @param {object} data The data of the booking
    * @description
    * Update data on the booking collections
    *
    * @returns {string} Returns the answer
    ###
    $update: (data) ->
      data ||= @getPostData()
      @$put('self', {}, data).then (res) =>
        @constructor(res) 
        BookingCollections.checkItems(@)

    $refetch: () ->
      @$flush('self')
      @$get('self').then (res) =>
        @constructor(res)
        BookingCollections.checkItems(@)

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} slot_id The booking slot id.
    * @param {date=} start_date Booking start date.
    * @param {date=} end_date Booking end date.
    * @param {integer=} service_id The service id.
    * @param {integer=} resource_id The resource id.
    * @param {integer=} person_id The person id.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @param {array} include_cancelled An array with booking list what include cancelled booking.
    * @methodOf BB.Models:AdminBooking
    * @description
    * Gets a filtered collection of bookings.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of bookings.
    ###
    @query: (company, slot_id, start_date, end_date, service_id, resource_id, person_id, page, per_page, include_cancelled) ->
      AdminBookingService.query
        company: company
        slot_id:slot_id
        start_date:start_date
        end_date: end_date
        service_id: service_id
        resource_id: resource_id
        person_id: person_id
        page: page
        per_page: per_page
        include_cancelled: include_cancelled

angular.module('BB.Models').factory 'AdminBooking', ($injector) ->
  $injector.get('Admin.BookingModel')
