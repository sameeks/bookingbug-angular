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
    * @param {Company} company The company model.
    * @param {integer=} company_id The company id
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @param {date=} start_date The schedule start date.
    * @param {date=} end_date The schedule end date.
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Gets a filtered collection of schedules.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of schedules.
    ###
    @query: (company, company_id, page, per_page, start_date, end_date) ->
      AdminScheduleService.query
        company: company
        company_id: company_id
        page: page
        per_page: per_page
        start_date: start_date
        end_date: end_date

    ###**
    * @ngdoc method
    * @name delete
    * @param {Company} company The company model.
    * @param {integer=} id The schedule id is required
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Delete a filtered collection of schedules.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of schedules.
    ###
    @delete: (company, id) ->
      AdminScheduleService.delete
        company: company
        id: id

    ###**
    * @ngdoc method
    * @name update
    * @param {Company} company The company model.
    * @param {string=} rules Schedule rules for update.
    * @param {string=} name Schedule name.
    * @param {string=} desc Schedule description.
    * @param {string=} style Schedule style.
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Update a filtered collection of schedules.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of schedules.
    ###
    @update: (company, page, per_page) ->
      AdminScheduleService.update
        company: company
        page: page
        per_page: per_page

angular.module('BB.Models').factory 'AdminSchedule', ($injector) ->
  $injector.get('Admin.ScheduleModel')