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
    * @methodOf BB.Models:AdminSlot
    * @description
    * Static function that loads an array of slots from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (prms) ->
      AdminSlotService.query (prms)
        

    ###**
    * @ngdoc method
    * @name create
    * @methodOf BB.Models:AdminSlot
    * @description
    * Static function that create an array of slots from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$create: (prms, data) ->
      AdminSlotService.create(prms, data)
    
    ###**
    * @ngdoc method
    * @name update
    * @methodOf BB.Models:AdminSlot
    * @description
    * Static function that updated an array of slots from a company object
    *
    * @returns {array} A returned promise
    ###
    @$update: (item, data) ->
      AdminSlotService.update(item, data)

    ###**
    * @ngdoc method
    * @name delete
    * @param {item}
    * @methodOf BB.Models:AdminSlot
    * @description
    * Static function that delete an array of slots from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$delete: (item) ->
      AdminSlotService.delete (item)

angular.module('BB.Models').factory ('AdminSlot'), ($injector) ->
  $injector.get('Admin.SlotModel')