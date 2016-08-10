
angular.module('BB.Models').factory "Member.BookingCollectionModel", ($q, BBModel, BaseCollectionModel) ->

  class Member_BookingCollection extends BaseCollectionModel


    constructor: (resource) ->
      super(resource)
      @initialise('bookings', BBModel.Member.Booking)


    initialise: (key, model) ->
      super(key, model)


    getNext: () ->
      super(BBModel.Member.BookingCollection)
