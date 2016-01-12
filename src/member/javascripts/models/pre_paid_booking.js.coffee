

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
    * @methodOf BB.Models:MemberPrePaidBooking
    * @description
    * Static function that loads an array of pre paid bookings from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query:(member, params) ->
      MemberPrePaidBookingService.query(member, params)

angular.module('BB.Models').factory 'MemberPrePaidBooking', ($injector) ->
  $injector.get('Member.PrePaidBookingModel')