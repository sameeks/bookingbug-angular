'use strict';

###**
* @ngdoc service
* @name BB.Models:PurchaseBooking
*
* @description
* Representation of an PurchaseBooking Object
*
* @property {boolean} ready Verify if booking is ready for purchase or not
* @property {date} datetime The booking date and time
* @property {date} time_zone The time zone
* @property {date} original_datetime The original date and time
* @property {date} end_date The end date of the booking
####

angular.module('BB.Models').factory "Purchase.BookingModel", ($q, $window, BBModel, BaseModel, $bbug, PurchaseBookingService) ->

  class Purchase_Booking extends BaseModel
    constructor: (data) ->
      super(data)
      @ready = false

      @datetime = moment.parseZone(@datetime)
      @datetime.tz(@time_zone) if @time_zone

      @original_datetime = moment(@datetime)

      @end_datetime = moment.parseZone(@end_datetime)
      @end_datetime.tz(@time_zone) if @time_zone

      @min_cancellation_time = moment(@min_cancellation_time)
      @min_cancellation_hours = @datetime.diff(@min_cancellation_time, 'hours')

    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the event group.
    *
    * @returns {object} Returns the group
    ###
    getGroup: () ->
      return @group if @group
      if @_data.$has('event_groups')
        @_data.$get('event_groups').then (group) =>
          @group = group
          @group

    ###**
    * @ngdoc method
    * @name getColour
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the group colour.
    *
    * @returns {string} Returns the colour
    ###
    getColour: () ->
      if @getGroup()
        return @getGroup().colour
      else
        return "#FFFFFF"

    ###**
    * @ngdoc method
    * @name getCompany
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the company.
    *
    * @returns {object} Returns the comapny
    ###
    getCompany: () ->
      return @company if @company
      if @$has('company')
        @_data.$get('company').then (company) =>
          @company = new BBModel.Company(company)
          @company

    ###**
    * @ngdoc method
    * @name $getAnswers
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Static function that gets the answers
    *
    * @returns {Promise} A promise that on success will return an array of answers
    ###
    $getAnswers: () =>
      defer = $q.defer()
      if @answers?
        defer.resolve(@answers)
      else
        @answers = []
        if @_data.$has('answers')
          @_data.$get('answers').then (answers) =>
            @answers = (new BBModel.Answer(a) for a in answers)
            defer.resolve(@answers)
        else
          defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name $getSurveyAnswers
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Static function that gets the survey answers.
    *
    * @returns {Promise} A promise that on success will return an array of survey answers
    ###
    $getSurveyAnswers: () =>
      defer = $q.defer()
      defer.resolve(@survey_answers) if @survey_answers
      if @_data.$has('survey_answers')
        @_data.$get('survey_answers').then (survey_answers) =>
          @survey_answers = (new BBModel.Answer(a) for a in survey_answers)
          defer.resolve(@survey_answers)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name answer
    * @methodOf BB.Models:PurchaseBooking
    * @param {string} q The question
    * @description
    * Verifies if answers have text or not in according of the q parameter.
    *
    * @returns {string} Returns question text or null
    ###
    answer: (q) ->
      if @answers?
        for a in @answers
          if a.name && a.name == q
            return a.answer
          if a.question_text && a.question_text == q
            return a.value
      else
        @$getAnswers()
      return null

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the post data.
    *
    * @returns {object} Returns newwly created data object
    ###
    getPostData: () ->

      data = {}

      data.attended = @attended
      data.client_id = @client_id
      data.company_id = @company_id
      data.time = (@datetime.hour() * 60) + @datetime.minute()
      data.date = @datetime.toISODate()
      data.deleted = @deleted
      data.describe = @describe
      data.duration = @duration
      data.end_datetime = @end_datetime

      # is the booking being moved (i.e. new time/new event) or are we just updating
      # the existing booking
      if @time and @time.event_id and !@isEvent()
        data.event_id = @time.event_id
      else if @event
        data.event_id = @event.id
      else
        data.event_id = @slot_id

      data.full_describe = @full_describe
      data.id = @id
      data.min_cancellation_time =  @min_cancellation_time
      data.on_waitlist = @on_waitlist
      data.paid = @paid
      data.person_name = @person_name
      data.price = @price
      data.purchase_id = @purchase_id
      data.purchase_ref = @purchase_ref
      data.quantity = @quantity
      data.self = @self
      data.move_item_id = @move_item_id if @move_item_id
      data.move_item_id = @srcBooking.id if @srcBooking
      data.person_id = @person.id if @person
      data.service_id = @service.id if @service
      data.resource_id = @resource.id if @resource
      data.questions = @item_details.getPostData() if @item_details
      data.service_name = @service_name
      data.settings = @settings
      data.status = @status if @status
      if @email?
        data.email = @email
      if @email_admin?
        data.email_admin = @email_admin
      data.first_name = @first_name if @first_name
      data.last_name = @last_name if @last_name

      formatted_survey_answers = []
      if @survey_questions
        data.survey_questions = @survey_questions
        for q in @survey_questions
          formatted_survey_answers.push({value: q.answer, outcome: q.outcome, detail_type_id: q.id, price: q.price})
        data.survey_answers = formatted_survey_answers

      return data

    ###**
    * @ngdoc method
    * @name checkReady
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Checks if the booking is ready.
    *
    * @returns {boolean} Returns true if booking is ready
    ###
    checkReady: ->
      if (@datetime && @id && @purchase_ref)
        @ready = true

    ###**
    * @ngdoc method
    * @name printed_price
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Prints the booking price.
    *
    * @returns {number} Returns the price of booking
    ###
    printed_price: () ->
      return "£" + parseInt(@price) if parseFloat(@price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@price))

    ###**
    * @ngdoc method
    * @name getDateString
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the date in string format.
    *
    * @returns {string} Returns the date in ISO format
    ###
    getDateString: () ->
      @datetime.toISODate()

    ###**
    * @ngdoc method
    * @name getTimeInMins
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the time in minutes.
    *
    * @returns {number} Returns the time of day in total minutes
    ###
    # return the time of day in total minutes
    getTimeInMins: () ->
      (@datetime.hour() * 60) + @.datetime.minute()

    ###**
    * @ngdoc method
    * @name getAttachments
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Gets the attachments.
    *
    * @returns {array} Returns the attachments
    ###
    getAttachments: () ->
      return @attachments if @attachments
      if @$has('attachments')
        @_data.$get('attachments').then (atts) =>
          @attachments = atts.attachments
          @attachments

    canCancel: () ->
      return moment(@min_cancellation_time).isAfter(moment())

    canMove: () ->
      return @canCancel()

    getAttendeeName: () ->
      return "#{@first_name} #{@last_name}"

    ###**
    * @ngdoc method
    * @name $update
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Static function that updated an array of booking from a company object
    *
    * @returns {promise} A promise that on success will return the updated purchase booking object
    ###
    @$update: (booking) ->
      PurchaseBookingService.update(booking)

    ###**
    * @ngdoc method
    * @name isEvent
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Checks if the booking is an event chain.
    *
    * @returns {boolean} True or false
    ###
    isEvent: () ->
      return @event_chain?
