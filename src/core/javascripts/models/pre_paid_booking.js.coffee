
###**
* @ngdoc service
* @name BB.Models:PrePaidBooking
*
* @description
* Representation of an PrePaidBooking Object
####

angular.module('BB.Models').factory "PrePaidBookingModel", ($q, BBModel, BaseModel) ->

  class PrePaidBooking extends BaseModel

    constructor: (data) ->
      super(data)

      @book_by  = moment(@book_by)  if @book_by
      @use_by   = moment(@use_by)   if @use_by
      @use_from = moment(@use_from) if @use_from
      # TODO remove once api updated to not return expired prepaid bookings
      @expired = (@book_by and moment().isAfter(@book_by, 'day')) or (@use_by and moment().isAfter(@use_by, 'day')) or false


    checkValidity: (item) ->
      if @service_id && item.service_id && @service_id != item.service_id
        false
      else if @resource_id && item.resource_id && @resource_id != item.resource_id
        false
      else if @person_id && item.person_id && @person_id != item.person_id
        false
      else
        true
