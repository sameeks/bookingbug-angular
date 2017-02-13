/***
* @ngdoc service
* @name BB.Models:TimeSlot
*
* @description
* Representation of an TimeSlot Object
*
* @property {number} avail Indicates if the slot is available
* @property {moment} datetime Moment representation of the time slot
* @property {number} event_id The event id assoicated to the time slot
* @property {number} price The price assoicated to the time slot
* @property {object} service The service assoicataed to the time slot

* @property {boolean} selected Indicates if the slot is selected
*/


angular.module('BB.Models').factory("TimeSlotModel", ($q, $window, BBModel, BaseModel, TimeService) =>

  class TimeSlot extends BaseModel {

    constructor(data, service) {
      super(data);
      this.service = service;
      this.datetime = moment.parseZone(this.datetime);
    }


    /***
    * @ngdoc method
    * @name endDateTime
    * @methodOf BB.Models:TimeSlot
    * @description
    * Calculates the end datetime using the provided duration or the duration from the service.
    *
    * @param {number} Optional duration
    * @returns {moment} End datetime
    */
    endDateTime(dur) {
      let duration;
      if (!dur) { duration = this.service.listed_durations[0]; }
      return this.datetime.clone().add(duration, 'minutes');
    }

    /***
    * @ngdoc method
    * @name availability
    * @methodOf BB.Models:TimeSlot
    * @description
    * Get availability
    *
    * @returns {number} Availability (> 0 means the slot is available)
    */
    availability() {
      return this.avail;
    }

    /***
    * @ngdoc method
    * @name select
    * @methodOf BB.Models:TimeSlot
    * @description
    * Select the time slot
    *
    * @returns {boolean} Selected status
    */
    select() {
      return this.selected = true;
    }

    /***
    * @ngdoc method
    * @name unselect
    * @methodOf BB.Models:TimeSlot
    * @description
    * Unselect time slot
    *
    */
    unselect() {
      if (this.selected) { return delete this.selected; }
    }

    /***
    * @ngdoc method
    * @name disable
    * @methodOf BB.Models:TimeSlot
    * @description
    * Disable time slot by reason
    *
    */
    disable(reason){
      this.disabled = true;
      return this.disabled_reason = reason;
    }

    /***
    * @ngdoc method
    * @name enable
    * @methodOf BB.Models:TimeSlot
    * @description
    * Enable time slot
    *
    */
    enable() {
      if (this.disabled) { delete this.disabled; }
      if (this.disabled_reason) { return delete this.disabled_reason; }
    }

    /***
    * @ngdoc method
    * @name status
    * @methodOf BB.Models:TimeSlot
    * @description
    * Get the status of the time slot
    *
    * @returns {string} Status of the time slot
    */
    status() {
      if (this.selected) { return "selected"; }
      if (this.disabled) { return "disabled"; }
      if (this.availability() > 0) { return "enabled"; }
      return "disabled";
    }

    static $query(params) {
      return TimeService.query(params);
    }
  }
);

