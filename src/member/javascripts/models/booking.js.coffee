'use strict';

###**
* @ngdoc service
* @name BB.Models:MemberBooking
*
* @description
* Representation of an Booking Object
*
* @property {integer} price The booking price
* @property {integer} paid Booking paid
####


angular.module('BB.Models').factory "Member.BookingModel", ($q, $window, BBModel, BaseModel, $bbug, MemberBookingService) ->

  class Member_Booking extends BaseModel
    constructor: (data) ->
      super(data)

      @datetime = moment.parseZone(@datetime)
      @datetime.tz(@time_zone) if @time_zone

      @end_datetime = moment.parseZone(@end_datetime)
      @end_datetime.tz(@time_zone) if @time_zone

    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:MemberBooking
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
    * @methodOf BB.Models:MemberBooking
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
    * @methodOf BB.Models:MemberBooking
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
    * @name getAnswers
    * @methodOf BB.Models:MemberBooking
    * @description
    * Get answers
    *
    * @returns {Promise} Returns a promise which resolve the answers
    ###
    getAnswers: () ->
      defer = $q.defer()
      defer.resolve(@answers) if @answers
      if @_data.$has('answers')
        @_data.$get('answers').then (answers) =>
          @answers = (new BBModel.Answer(a) for a in answers)
          defer.resolve(@answers)
      else
        defer.resolve([])
      defer.promise

    ###**
    * @ngdoc method
    * @name printed_price
    * @methodOf BB.Models:MemberBooking
    * @description
    * Print price for the booking
    *
    * @returns {integer} Returns the price of the booking
    ###
    printed_price: () ->
      return "£" + @price if parseFloat(@price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@price))

    ###**
    * @ngdoc method
    * @name getMemberPromise
    * @methodOf BB.Models:MemberBooking
    * @description
    * Get member promise
    *
    * @returns {Promise} Returns a promise which resolve the member promise
    ###
    getMemberPromise: () =>
      defer = $q.defer()
      defer.resolve(@member) if @member
      if @_data.$has('member')
        @_data.$get('member').then (member) =>
          @member = new BBModel.Member.Member(member)
          defer.resolve(@member)
      defer.promise

    canCancel: () ->
      return moment(@min_cancellation_time).isAfter(moment())

    canMove: () ->
      return @canCancel()

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} company_id The id of company that use the booking.
    * @param {integer=} member_id The member id what use the booking.
    * @param {date=} start_date Booking start date.
    * @param {date=} end_date Booking end date.
    * @param {array} include_cancelled An array with booking list what include cancelled booking.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:MemberBooking
    * @description
    * Gets a filtered collection of bookings.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of bookings.
    ###
    @query: (company, company_id, member_id, start_date, end_date, include_cancelled, page, per_page) ->
      MemberBookingService.query
        company: company
        company_id: company_id
        member_id: member_id
        start_date: start_date
        end_date: end_date
        include_cancelled: include_cancelled
        page: page
        per_page: per_page

    ###**
    * @ngdoc method
    * @name update
    * @param {Company} company The company model.
    * @param {integer=} company_id The id of company that use the booking.
    * @param {integer=} member_id The member id what use the booking.
    * @param {integer=} id The booking id.
    * @methodOf BB.Models:MemberBooking
    * @description
    * Update a filtered collection of bookings.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of updated bookings.
    ###
    @update: (company, company_id, member_id, id) ->
      MemberBookingService.update
        company: company
        company_id: company_id
        member_id: member_id
        id: id

angular.module('BB.Models'). factory 'MemberBooking', ($injector) ->
  $injector.get('Member.BookingModel')
