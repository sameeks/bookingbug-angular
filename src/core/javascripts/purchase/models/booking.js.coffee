'use strict';


###**
* @ngdoc service
* @name BB.Models:PurchaseBooking
*
* @description
* Representation of an Purchase Booking Object
*
* @property {integer} price The booking price
* @property {integer} paid Booking paid
####


angular.module('BB.Models').factory "Purchase.BookingModel", ($q, $window, BBModel, BaseModel, $bbug) ->


  class Purchase_Booking extends BaseModel
    constructor: (data) ->
      super(data)
      @ready = false
  
      @datetime = moment.parseZone(@datetime) 
      @datetime.tz(@time_zone) if @time_zone
      @original_datetime = moment(@datetime)

      @end_datetime = moment.parseZone(@end_datetime)
      @end_datetime.tz(@time_zone) if @time_zone
 
    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get group
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
    * Get colour
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
    * Get company
    *
    * @returns {object} Returns the company
    ###
    getCompany: () ->
      return @company if @company
      if @$has('company')
        @_data.$get('company').then (company) =>
          @company = new BBModel.Company(company)
          @company


    ###**
    * @ngdoc method
    * @name getAnswersPromise
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get answers promise
    *
    * @returns {Promise} Returns a promise that resolve the answers promises
    ###
    getAnswersPromise: () =>
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
    * @name getSurveyAnswersPromise
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get survey answers promise
    *
    * @returns {Promise} Returns a promise that resolve the survey answers promises
    ###
    getSurveyAnswersPromise: () =>
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
    * @param {string} q The question answer
    * @description
    * Get the answer
    *
    * @returns {string} Returns the answer or not
    ###
    answer: (q) ->
      if @answers?
        for a in @answers
          if a.name && a.name == q
            return a.answer
          if a.question_text && a.question_text == q
            return a.value
      else
        @getAnswersPromise()
      return null

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get post data
    *
    * @returns {array} Returns data
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
      data.event_id = @event.id if @event
      data.event_id = @time.event_id if @time && @time.event_id
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
    * Check if booking is ready to purchase or not
    *
    * @returns {boolean} Returns true or false
    ###
    checkReady: ->
      if (@datetime && @id && @purchase_ref)
        @ready = true

    ###**
    * @ngdoc method
    * @name printed_price
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Print price for the booking
    *
    * @returns {integer} Returns the price of the booking
    ###
    printed_price: () ->
      return "£" + parseInt(@price) if parseFloat(@price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@price))

    ###**
    * @ngdoc method
    * @name getDateString
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get the date in string format
    *
    * @returns {string} Returns the date
    ###
    getDateString: () ->
      @datetime.toISODate()


    ###**
    * @ngdoc method
    * @name getTimeInMins
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get the time in minutes
    *
    * @returns {date} Returns the time of day in total minutes
    ###
    # return the time of day in total minutes
    getTimeInMins: () ->
      (@datetime.hour() * 60) + @.datetime.minute()

    ###**
    * @ngdoc method
    * @name getAttachments
    * @methodOf BB.Models:PurchaseBooking
    * @description
    * Get the booking attachments
    *
    * @returns {object} Returns booking attachments
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

