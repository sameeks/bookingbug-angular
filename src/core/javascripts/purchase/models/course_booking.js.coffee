
###**
* @ngdoc service
* @name BB.Models:PurchaseCourseBooking
*
* @description
* Representation of an Purchase Course Booking Object
*
* @property {integer} price The booking price
* @property {integer} paid Booking paid
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
    * Get bookings
    *
    * @returns {Promise} Returns a promise that resolve the getting bookings
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
