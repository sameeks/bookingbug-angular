

###**
* @ngdoc service
* @name BB.Models:MemberPrePaidBooking
*
* @description
* Representation of an PrePaidBooking Object
####


angular.module('BB.Models').factory "Member.PrePaidBookingModel", ($q, BBModel, BaseModel, MemberPrePaidBookingService) ->

  class Member_PrePaidBooking extends BaseModel
    constructor: (data) ->
      super(data)
    
    ###**
    * @ngdoc method
    * @name checkValidity
    * @methodOf BB.Models:MemberPrePaidBooking
    * @param {object} event The event
    * @description
    * Check if pre paid booking is valid or not in according of the event parameter
    *
    * @returns {boolean} Returns true or false
    ###
    checkValidity: (event) ->
      if @service_id && event.service_id && @service_id != event.service_id
        false
      else if @resource_id && event.resource_id && @resource_id != event.resource_id
        false
      else if @person_id && event.person_id && @person_id != event.person_id
        false
      else
        true

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} company_id The company id.
    * @param {integer=} member_id The id of member that use pre paid the booking.
    * @param {array} include_invalid An array with booking list that include invalid booking.
    * @param {integer=} event_id The event id
    * @methodOf BB.Models:MemberPrePaidBooking
    * @description
    * Gets a filtered collection of pre paid bookings.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of pre paid bookings.
    ###
    @query: (company, company_id, member_id, include_invalid, event_id) ->
      MemberPrePaidBookingService.query
        company: company
        company_id: company_id
        member_id: member_id
        include_invalid: include_invalid
        event_id: event_id

angular.module('BB.Models').factory 'MemberPrePaidBooking', ($injector) ->
  $injector.get('Member.PrePaidBookingModel')