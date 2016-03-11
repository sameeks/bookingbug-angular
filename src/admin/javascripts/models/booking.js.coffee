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
* @property {string} title Booking title
* @property {integer} time Booking time
* @property {boolean} allDay Booking availability of the day
* @property {integer} status The status of the booking
####

angular.module('BB.Models').factory "Admin.BookingModel", ($q, BBModel, BaseModel, BookingCollections, AdminBookingService) ->

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
    * (!!check)Provides information about the date, time, duration and questions
    *
    * @returns {object} Data object
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
    * @param {boolean} status Booking status
    * @description
    * Verifies if a booking status is setted
    *
    * @returns {boolean} False or True if status was setted
    ###
    hasStatus: (status) ->
      @multi_status[status]?

    ###**
    * @ngdoc method
    * @name statusTime
    * @methodOf BB.Models:AdminBooking
    * @param {boolean} status Booking status
    * @description
    *
    * @returns {object} Returns a decorated object that contains information about the date
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
    * @param {boolean} status Booking status
    * @description
    * Verifies the status time depending on the status parameter
    *
    * @returns {integer} Returns 0 if status time is null or the status unix time
    ###
    sinceStatus: (status) ->
      s = @statusTime(status)
      return 0 if !s
      return Math.floor((moment().unix() - s.unix()) / 60)

    ###**
    * @ngdoc method
    * @name sinceStart
    * @methodOf BB.Models:AdminBooking
    * @param {object} options Booking options
    * @description
    * Gets the booking start time depending on the options parameter
    *
    * @returns {integer} Booking start time
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
    * @param {string} q Booking question
    * @description
    * Gets the answer depending on the q parameter
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
    * @param {object} Booking data
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
    * @methodOf BB.Models:AdminBooking
    * @description
    * Static function that loads an array of bookings from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (prms) ->
      AdminBookingService.query(prms)

angular.module('BB.Models').factory 'AdminBooking', ($injector) ->
  $injector.get('Admin.BookingModel')
