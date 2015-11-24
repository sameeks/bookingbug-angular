'use strict';


###**
* @ngdoc service
* @name BB.Models:AdminSlot
*
* @description
* Representation of an Slot Object
*
* @property {integer} total_entries The The total entries of the slot
* @property {array} slots An array with slots
####


angular.module('BB.Models').factory "Admin.SlotModel", ($q, BBModel, BaseModel, TimeSlotModel, AdminSlotService) ->

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
    * @param {date=} end_date The slot end time.
    * @param {date=} date The single date.
    * @param {integer=} resource_id The resource id.
    * @param {integer=} service_id The resource id.
    * @param {integer=} person_id The person id.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminSlot
    * @description
    * Gets a filtered collection of slots.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of slots.
    ###
    @query: (company, start_date, end_date, date, service_id, resource_id, person_id, page, per_page) ->
      AdminSlotService.query
        company: company
        start_date: start_date
        end_date: end_date
        date: date
        service_id: service_id
        resource_id: resource_id
        person_id: person_id
        page: page
        per_page: per_page

    ###**
    * @ngdoc method
    * @name create
    * @param {Company} company The company model.
    * @param {date=} start_time The start time (format:2001-02-03T17:05:06).
    * @param {date=} end_date The end date (format:2001-02-03T17:05:06).
    * @param {boolean=} allday Slot are used all day or not.
    * @param {integer=} person_id The person id.
    * @param {integer=} resource_id The resource id.
    * @methodOf BB.Models:AdminSlot
    * @description
    * Create a filtered collection of slots.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of slots.
    ###
    @create: (company, start_time, end_time, allday, person_id, resource_id) ->
      AdminSlotService.create
        company: company
        start_time: start_time
        end_time: end_time
        allday: allday 
        person_id: person_id
        resource_id: resource_id
    
    ###**
    * @ngdoc method
    * @name update
    * @param {Company} company The company model.
    * @param {integer=} id The slot id.
    * @param {date=} start_time The start time (format:2001-02-03T17:05:06).
    * @param {date=} end_time The end time (format:2001-02-03T17:05:06).
    * @methodOf BB.Models:AdminSlot
    * @description
    * Update a filtered collection of slots.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of slots.
    ###
    @update: (company, id, start_time, end_time) ->
      AdminSlotService.update
        company: company
        start_time: start_time
        end_time: end_time

    ###**
    * @ngdoc method
    * @name delete
    * @param {Company} company The company model.
    * @param {integer=} id The slot id.
    * @methodOf BB.Models:AdminSlot
    * @description
    * Delete a filtered collection of slots.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of slots.
    ###
    @delete: (company, id) ->
      AdminSlotService.delete
        company: company
        id: id

angular.module('BB.Models').factory ('AdminSlot'), ($injector) ->
  $injector.get('Admin.SlotModel')