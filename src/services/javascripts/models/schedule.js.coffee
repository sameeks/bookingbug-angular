'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminSchedule
*
* @description
* Representation of an Schedule Object
*
* @property {integer} id Schedule id
* @property {string} rules Schedule rules
* @property {string} name Schedule name
* @property {integer} company_id The company id
* @property {date} duration The schedule duration
####


angular.module('BB.Models').factory "Admin.ScheduleModel", ($q, BBModel, BaseModel, AdminScheduleService) ->

  class Admin_Schedule extends BaseModel

    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Get post data
    *
    * @returns {array} Returns data. 
    ###
    getPostData: () ->
      data = {}
      data.id = @id
      data.rules = @rules
      data.name = @name
      data.company_id = @company_id
      data.duration = @duration
      data
    
    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Static function that loads an array of admin schedule service from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
      AdminScheduleService.query(params)

    ###**
    * @ngdoc method
    * @name delete
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Static function that deleted an array of administrator service from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$delete: (schedule) ->
      AdminScheduleService.delete(schedule)

    ###**
    * @ngdoc method
    * @name update
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Static function that updated an array of schedule from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$update: (schedule) ->
      AdminScheduleService.update(schedule)

angular.module('BB.Models').factory 'AdminSchedule', ($injector) ->
  $injector.get('Admin.ScheduleModel')