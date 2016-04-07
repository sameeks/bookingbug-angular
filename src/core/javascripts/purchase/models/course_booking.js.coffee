
###**
* @ngdoc service
* @name BB.Models:PurchaseCourseBooking
*
* @description
* Representation of an PurchaseCourseBooking Object
*
* @property {number} price The booking price
* @property {number} paid Booking paid
####

angular.module('BB.Models').factory "Purchase.CourseBookingModel", ($q, BBModel, BaseModel) ->

  class Purchase_Course_Booking extends BaseModel
    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name getBookings
    * @methodOf BB.Models:PurchaseCourseBooking
    * @description
    * Gets the purchase bookings.
    *
    * @returns {Promise} A promise that on success will return an array of purchase bookings
    ###
    getBookings: =>
      defer = $q.defer()
      defer.resolve(@bookings) if @bookings
      if @_data.$has('bookings')
        @_data.$get('bookings').then (bookings) =>
          @bookings = (new BBModel.Purchase.Booking(b) for b in bookings)
          @bookings.sort (a, b) => a.datetime.unix() - b.datetime.unix()
          defer.resolve(@bookings)
      else
        @bookings = []
        defer.resolve(@bookings)
      defer.promise
