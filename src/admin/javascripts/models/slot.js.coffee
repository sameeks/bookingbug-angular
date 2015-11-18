'use strict';


###**
* @ngdoc service
* @name BB.Models:AdminSlot
*
* @description
* Representation of an Slot Object
*
* @property {integer} total_entires The total entires of slot
* @property {array} slots An array with slots
###


angular.module('BB.Models').factory "Admin.SlotModel", ($q, BBModel, BaseModel, TimeSlotModel) ->

  class Admin_Slot extends TimeSlotModel

    constructor: (data) ->
      super(data)
      @title = @full_describe
      if @status == 0
        @title = "Available"
      @datetime = moment(@datetime)
      @start = @datetime
      @end = @datetime.clone().add(@duration, 'minutes')
      @time = @start.hour()* 60 + @start.minute()
      @allDay = false
      if @status == 3
        @className = "status_blocked"
      else if @status == 4
        @className = "status_booked"
      else if @status == 0
        @className = "status_available"

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {date=} start_date The slot start date.
    * @param {date=} end_date The slot end date.
    * @param {date=} date The slot date.
    * @param {integer=} resource_id Slot resource id.
    * @param {integer=} service_id Slot service id.
    * @param {integer=} person_id User person id.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminSlot
    * @description
    * Gets a filtered collection of slots.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of slots.
    ###
    @query: (company, start_date, end_date, date, resource_id, service_id, person_id, page, per_page) ->
      AdminSlotService.query
        company: company
        start_date: start_date
        end_date: end_date
        date: date
        resource_id: resource_id
        service_id: service_id
        person_id: person_id
        page: page
        per_page: per_page

    ###**
    * @ngdoc method
    * @name delete
    * @param {Company} company The company model.
    * @param {integer=} company_id The id of company that use the slot.
    * @param {integer=} id The slot id
    * @methodOf BB.Models:AdminSlot
    * @description
    * Delete slot in according of the company, company_id and id parameters.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of deleted slots.
    ###
    @delete: (company, company_id, id) ->
      AdminSlotService.delete
        company: company
        company_id: company_id
        id: id

    ###**
    * @ngdoc method
    * @name update
    * @param {Company} company The company model.
    * @param {integer=} company_id The id of company that use the slot.
    * @param {integer=} id The slot id
    * @param {date=} start_time The slot start time.
    * @param {date=} end_time The slot end time.
    * @methodOf BB.Models:AdminSlot
    * @description
    * Update slot in according of company, company_id, id, start_time and end_time parameters.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of updated slots.
    ###
    @update: (company, company_id, id, start_time, end_time) ->
      AdminSlotService.update
        company: company
        company_id: company_id
        id: id
        start_time: start_time
        end_time: end_time

angular.module('BB.Models').factory 'AdminSlot', ($injector) ->
  $injector.get('Admin.SlotModel')