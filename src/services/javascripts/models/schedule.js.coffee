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


angular.module('BB.Models').factory "Admin.ScheduleModel", ($q, BBModel, BaseModel) ->

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
    
