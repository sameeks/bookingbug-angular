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


angular.module('BB.Models').factory "Admin.ServiceModel", ($q, BBModel, ServiceModel) ->


  class Admin_Service extends ServiceModel

# 	###**
# 	* @ngdoc method
# 	* @name query
# 	* @param {Company} company The company model.
# 	* @param {integer=} company_id The company id
# 	* @param {integer=} page Specifies particular page of paginated response.
# 	* @param {integer=} per_page Number of items per page of paginated response.
# 	* @param {string =} api_ref The service api reference
# 		* @methodOf BB.Models:AdminSchedule
# 	* @description
# 	* Gets a filtered collection of schedules.
# 	*
# 	* @returns {Promise} Returns a promise that resolves to the filtered collection of schedules.
# 	###
# 	@query: (company, company_id, page, per_page, api_ref) ->
# 	   AdminServiceService.query
# 	    company: company
# 	    company_id: company_id
# 	    page: page
# 	    per_page: per_page
# 			api_ref: api_ref

# angular.module('BB.Models').factory 'AdminService', ($injector) ->
#   $injector.get('Admin.ServiceModel')