'use strict';


###**
* @ngdoc service
* @name BB.Models:AdminService
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


angular.module('BB.Models').factory "Admin.ServiceModel", ($q, BBModel, ServiceModel, AdminServiceService) ->


  class Admin_Service extends ServiceModel

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminService
    * @description
    * Static function that loads an array of services from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
        AdminServiceService.query(params)

angular.module('BB.Models').factory 'AdminService', ($injector) ->
  $injector.get('Admin.ServiceModel')