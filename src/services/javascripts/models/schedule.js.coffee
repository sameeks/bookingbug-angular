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

angular.module('BB.Models').factory "Admin.ScheduleModel", ($q, AdminScheduleService, BBModel, BaseModel, ScheduleRules) ->

  class Admin_Schedule extends BaseModel

    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Gets the post data
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
    * Static function that loads an array of admin schedules from a company object
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
    * Static function that deletes an admin schedule from a company object
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
    * Static function that updates an admin schedule from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$update: (schedule) ->
      AdminScheduleService.update(schedule)
