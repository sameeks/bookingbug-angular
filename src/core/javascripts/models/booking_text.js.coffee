'use strict'

angular.module('BB.Models').factory "BookingTextModel", ($q, BBModel, BaseModel) ->
  console.log('BookingText model loaded')
  class BookingText extends BaseModel
