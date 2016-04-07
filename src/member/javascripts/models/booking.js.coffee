'use strict';

###**
* @ngdoc service
* @name BB.Models:MemberBooking
*
* @description
* Representation of an Booking Object
*
* @property {number} Booking price
* @property {number} paid Booking paid
####

angular.module('BB.Models').factory "Member.BookingModel",
($q, $window, $bbug, MemberBookingService, BBModel, BaseModel) ->

  class Member_Booking extends BaseModel
    constructor: (data) ->
      super(data)

      @datetime = moment.parseZone(@datetime)
      @datetime.tz(@time_zone) if @time_zone

      @end_datetime = moment.parseZone(@end_datetime)
      @end_datetime.tz(@time_zone) if @time_zone


      @min_cancellation_time = moment(@min_cancellation_time)
      @min_cancellation_hours = @datetime.diff(@min_cancellation_time, 'hours')

    ###**
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:MemberBooking
    * @description
    * Gets the group.
    *
    * @returns {object} Group
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
    * Gets the colour.
    *
    * @returns {string} colour
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
    * Gets the company.
    *
    * @returns {object} Company
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
    * Gets the answers.
    *
    * @returns {Promise} A promise that on success will return an array with answer objects
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
    * Shows the price of a booking formatted for print.
    *
    * @returns {number} Booking price
    ###
    printed_price: () ->
      return "£" + @price if parseFloat(@price) % 1 == 0
      return $window.sprintf("£%.2f", parseFloat(@price))

    ###**
    * @ngdoc method
    * @name $getMember
    * @methodOf BB.Models:MemberBooking
    * @description
    * Gets the member.
    *
    * @returns {Promise} A promise that on success will return a member object
    ###
    $getMember: () =>
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
    * @methodOf BB.Models:MemberBooking
    * @description
    * Static function that loads an array of bookings for a member from a company object.
    *
    * @param {object} member member parameter
    * @param {object} paramas paramas parameter
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (member, params) ->
      MemberBookingService.query(member, params)

    ###**
    * @ngdoc method
    * @name $update
    * @methodOf BB.Models:MemberBooking
    * @description
    * Static function that updates an array of bookings from a company object.
    *
    * @param {object} booking booking parameter
    *
    * @returns {Promise} A returned promise
    ###
    @$update: (booking) ->
      MemberBookingService.update(booking)

    ###**
    * @ngdoc method
    * @name $cancel
    * @methodOf BB.Models:MemberBooking
    * @description
    * Static function that will cancel the member booking.
    *
    * @param {object} member member parameter
    * @param {object} booking booking parameter
    *
    * @returns {Promise} A returned promise
    ###
    @$cancel: (member, booking) ->
      MemberBookingService.cancel(member, booking)

    ###**
    * @ngdoc method
    * @name $flush
    * @methodOf BB.Models:MemberBooking
    * @description
    * Static function that will delete the member bookings.
    *
    * @param {object} member member parameter
    * @param {object} params params parameter
    *
    * @returns {Promise} A returned promise
    ###
    @$flush: (member, params) ->
      MemberBookingService.flush(member, params)

