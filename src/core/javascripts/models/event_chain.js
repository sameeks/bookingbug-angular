/***
* @ngdoc service
* @name BB.Models:EventChain
*
* @description
* Representation of an EventChain Object
*
* @property {integer} id The id of event chain
* @property {string} name Name of the event chain
* @property {string} description The description of the event
* @property {integer} capacity_view The capacity view
* @property {date} start_date Event chain start date
* @property {date} finish_date Event chain finish date
* @property {integer} price The price of the event chain
* @property {string} ticket_type Type of the ticket
* @property {boolean} course Verify is couse exist or not
*///


angular.module('BB.Models').factory("EventChainModel", function($q, BBModel, BaseModel, EventChainService, $translate) {

  let setCapacityView;
  return __initClass__(setCapacityView = undefined,
  class EventChain extends BaseModel {
    static initClass() {
  
      /***
      * @ngdoc method
      * @name setCapacityView
      * @methodOf BB.Models:EventChain
      * @description
      * Sets the capacity_view (referred to as the "spaces view" in admin console) to a more helpful String
      * @returns {String} code for the capacity_view
      */
      setCapacityView = function(capacity_view) {
        let capacity_view_str;
        switch (capacity_view) {
          case 0: capacity_view_str = "DO_NOT_DISPLAY"; break;
          case 1: capacity_view_str = "NUM_SPACES"; break;
          case 2: capacity_view_str = "NUM_SPACES_LEFT"; break;
          case 3: capacity_view_str = "NUM_SPACES_AND_SPACES_LEFT"; break;
          default: capacity_view_str = "NUM_SPACES_AND_SPACES_LEFT";
        }
        return capacity_view_str;
      };
    }

    constructor(data) {
      super(...arguments);
      this.capacity_view = setCapacityView(this.capacity_view);
      if (this.start_date) { this.start_date = moment(this.start_date); }
      if (this.end_date) { this.end_date = moment(this.end_date); }
    }

    name() {
      return this._data.name;
    }

    /***
    * @ngdoc method
    * @name isSingleBooking
    * @methodOf BB.Models:EventChain
    * @description
    * Verify if is a single booking
    *
    * @returns {array} If maximum number of bookings is equal with 1 and not have an ticket sets
    */
    isSingleBooking() {
      return (this.max_num_bookings === 1) && !this.$has('ticket_sets');
    }

    /***
    * @ngdoc method
    * @name hasTickets
    * @methodOf BB.Models:EventChain
    * @description
    * Checks if this is considered a valid tickets
    *
    * @returns {boolean} If this have an ticket sets
    */
    hasTickets() {
      return this.$has('ticket_sets');
    }

    /***
    * @ngdoc method
    * @name getTickets
    * @methodOf BB.Models:EventChain
    * @description
    * Get the tickets of the event
    *
    * @returns {promise} A promise for the tickets
    */
    getTickets() {
      let def = $q.defer();
      if (this.tickets) {
        def.resolve(this.tickets);
      } else {
        if (this.$has('ticket_sets')) {
          this.$get('ticket_sets').then(tickets => {
            this.tickets = [];
            for (let ticket of Array.from(tickets)) {
              // mark that this ticket is part of ticket set so that the range can be calculated correctly
              ticket.ticket_set = true;
              this.tickets.push(new BBModel.EventTicket(ticket));
            }
            this.adjustTicketsForRemaining();
            return def.resolve(this.tickets);
          }
          );
        } else {
          this.tickets = [new BBModel.EventTicket({
            name: $translate.instant('COMMON.TERMINOLOGY.ADMITTANCE'),
            min_num_bookings: 1,
            max_num_bookings: this.max_num_bookings,
            type: "normal",
            price: this.price
          })];
          this.adjustTicketsForRemaining();
          def.resolve(this.tickets);
        }
      }
      return def.promise;
    }

    /***
    * @ngdoc method
    * @name adjustTicketsForRemaining
    * @methodOf BB.Models:EventChain
    * @description
    * Adjust the number of tickets that can be booked due to changes in the number of remaining spaces for each ticket set
    *
    * @returns {object} The returned adjust tickets for remaining
    */
    adjustTicketsForRemaining() {
      if (this.tickets) {
        return (() => {
          let result = [];
          for (this.ticket of Array.from(this.tickets)) {
            result.push(this.ticket.max_spaces = this.spaces);
          }
          return result;
        })();
      }
    }


    static $query(prms) {
      return EventChainService.query(prms);
    }
  });
});


function __initClass__(c) {
  c.initClass();
  return c;
}