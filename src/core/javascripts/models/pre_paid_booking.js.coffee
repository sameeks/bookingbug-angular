angular.module('BB.Models').factory "PrePaidBookingModel", ($q, BBModel, BaseModel) ->

  class PrePaidBooking extends BaseModel

    constructor: (data) ->
      super(data)


    checkValidity: (item) ->
      if @service_id && item.service_id && @service_id != item.service_id
        false
      else if @resource_id && item.resource_id && @resource_id != item.resource_id
        false
      else if @person_id && item.person_id && @person_id != item.person_id
        false
      else
        true
