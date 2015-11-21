'use strict';


###**
* @ngdoc service
* @name BB.Models:Service
*
* @description
* Representation of an Service Object
*
* @property {integer} id Id of the service
* @property {string} name The name of service
* @property {date} duration Duration of the service
* @property {float} prices The prices of the service
* @property {integer} detail_group_id The detail group id
* @property {date} booking_time_step The time step of the booking
* @property {integer} min_bookings The minimum number of bookings
* @property {integer} max_booings The maximum number of bookings
###


angular.module('BB.Models').factory "ServiceModel", ($q, BBModel, BaseModel, ServiceService) ->

  class Service extends BaseModel

    constructor: (data) ->
      super
      if @prices && @prices.length > 0
        @price = @prices[0]
      if @durations && @durations.length > 0
        @duration = @durations[0]
      if !@listed_durations
        @listed_durations = @durations
      if @listed_durations && @listed_durations.length > 0
        @listed_duration = @listed_durations[0]

      @min_advance_datetime = moment().add(@min_advance_period, 'seconds')
      @max_advance_datetime = moment().add(@max_advance_period, 'seconds')

    ###**
    * @ngdoc method
    * @name getPriceByDuration
    * @methodOf BB.Models:Service
    * @description
    * Get price by duration in function of duration
    *
    * @returns {object} The returning price by duration 
    ###
    getPriceByDuration: (dur) ->
      for d,i in @durations
        return @prices[i] if d == dur
      # return price

    ###**
    * @ngdoc method
    * @name getCategoryPromise
    * @methodOf BB.Models:Service
    * @description
    * Get category promise
    *
    * @returns {object} The returning category promise 
    ###
    getCategoryPromise: () =>
      return null if !@$has('category')
      prom = @$get('category')
      prom.then (cat) =>
        @category = new BBModel.Category(cat)
      prom

    ###**
    * @ngdoc method
    * @name days_array
    * @methodOf BB.Models:Service
    * @description
    * Put days in array
    *
    * @returns {array} The returning days array 
    ###
    days_array: () =>
      arr = []
      for x in [@min_bookings..@max_bookings]
        str = "" + x + " day"
        str += "s" if x > 1
        arr.push({name: str, val: x})
      arr


    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Service
    * @description
    * Static function that loads an array of services from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company) ->
      ServiceService.query(company)

