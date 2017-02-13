// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Event
*
* @description
* This is the event object returned by the API
*
* @property {integer} id The event id
* @property {date} datetime The event date and time
* @property {string} description Description of the event
* @property {integer} status Status of the event
* @property {integer} spaces_booked The booked spaces
* @property {integer} duration Duration of the event
*///


angular.module('BB.Models').factory("EventModel", ($q, BBModel, BaseModel, DateTimeUtilitiesService, EventService, $translate) =>


  class Event extends BaseModel {

    constructor(data) {
      super(data);
      this.date = moment.parseZone(this.datetime);
      this.time = new BBModel.TimeSlot({time: DateTimeUtilitiesService.convertMomentToTime(this.date)});
      if (this.duration) { this.end_datetime = this.date.clone().add(this.duration, 'minutes'); }
      this.date_unix = this.date.unix();
    }

    /***
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:Event
    * @description
    * Get event groups
    *
    * @returns {promise} A promise for the group event
    */
    getGroup() {
      let defer = $q.defer();
      if (this.group) {
        defer.resolve(this.group);
      } else if (this.$has('event_groups') || this.$has('event_group')) {
        let event_group = 'event_group';
        if (this.$has('event_groups')) { event_group = 'event_groups'; }
        this.$get(event_group).then(group => {
          this.group = new BBModel.EventGroup(group);
          return defer.resolve(this.group);
        }
        , err => defer.reject(err));
      } else {
        defer.reject("No event group");
      }
      return defer.promise;
    }

    /***
    * @ngdoc method
    * @name getGroup
    * @methodOf BB.Models:Event
    * @description
    * Get the chains of the event
    *
    * @returns {promise} A promise for the chains event
    */
    getChain(params) {
      let defer = $q.defer();
      if (this.chain) {
        defer.resolve(this.chain);
      } else {
        if (this.$has('event_chains') || this.$has('event_chain')) {
          let event_chain = 'event_chain';
          if (this.$has('event_chains')) { event_chain = 'event_chains'; }
          this.$get(event_chain, params).then(chain => {
            this.chain = new BBModel.EventChain(chain);
            return defer.resolve(this.chain);
          }
          );
        } else {
          defer.reject("No event chain");
        }
      }
      return defer.promise;
    }

    /***
    * @ngdoc method
    * @name getDuration
    * @methodOf BB.Models:Event
    * @description
    * Get duration of the event chains
    *
    * @returns {promise} A promise for duration of the event
    */
    getDuration() {
      let defer = new $q.defer();
      if (this.duration) {
        defer.resolve(this.duration);
      } else {
        this.getChain().then(chain => {
          this.duration = chain.duration;
          return defer.resolve(this.duration);
        }
        );
      }
      return defer.promise;
    }


    /***
    * @ngdoc method
    * @name getDescription
    * @methodOf BB.Models:Event
    * @description
    * Get duration of the event
    *
    * @returns {object} The returned description
    */
    getDescription() {
      return this.getChain().description;
    }

    /***
    * @ngdoc method
    * @name getColour
    * @methodOf BB.Models:Event
    * @description
    * Get the colour
    *
    * @returns {string} The returned colour
    */
    getColour() {
      if (this.getGroup()) {
        return this.getGroup().colour;
      } else {
        return "#FFFFFF";
      }
    }


    /***
    * @ngdoc method
    * @name getPounds
    * @methodOf BB.Models:Event
    * @description
    * Get pounts
    *
    * @returns {integer} The returned pounts
    */
    getPounds() {
      if (this.chain) {
        return Math.floor(this.getPrice()).toFixed(0);
      }
    }

    /***
    * @ngdoc method
    * @name getPrice
    * @methodOf BB.Models:Event
    * @description
    * Get price
    *
    * @returns {integer} The returned price
    */
    getPrice() {
      return 0;
    }

    /***
    * @ngdoc method
    * @name getPence
    * @methodOf BB.Models:Event
    * @description
    * Get price
    *
    * @returns {integer} The returned pence
    */
    getPence() {
      if (this.chain) {
        return (this.getPrice() % 1).toFixed(2).slice(-2);
      }
    }

    /***
    * @ngdoc method
    * @name getNumBooked
    * @methodOf BB.Models:Event
    * @description
    * Get the number booked
    *
    * @returns {object} The returned number booked
    */
    getNumBooked() {
      return this.spaces_blocked + this.spaces_booked + this.spaces_reserved + this.spaces_held;
    }

    /***
    * @ngdoc method
    * @name getSpacesLeft
    * @methodOf BB.Models:Event
    * @description
    * Get the number of spaces left (possibly limited by a specific ticket pool)
    *
    * @returns {object} The returned spaces left
    */
    getSpacesLeft(pool) {
      if (pool == null) { pool = null; }
      if (pool && this.ticket_spaces && this.ticket_spaces[pool]) {
        return this.ticket_spaces[pool].left;
      } else {
        let x =  this.num_spaces - this.getNumBooked();
        if (x < 0) { return 0; }
        return x;
      }
    }


    /***
    * @ngdoc method
    * @name getWaitSpacesLeft
    * @methodOf BB.Models:Event
    * @description
    * Get the number of waitlist spaces left (possibly limited by a specific ticket pool)
    *
    * @returns {object} The returned spaces left
    */
    getWaitSpacesLeft() {
      let wait = this.chain.waitlength;
      if (!wait) { wait = 0; }
      wait = wait - this.spaces_wait;
      if (wait <= 0) { return 0; }

      return wait;
    }


    /***
    * @ngdoc method
    * @name hasSpace
    * @methodOf BB.Models:Event
    * @description
    * Checks if this considered a valid space
    *
    * @returns {boolean} If this is a valid space
    */
    hasSpace() {
      return (this.getSpacesLeft() > 0);
    }


    /***
    * @ngdoc method
    * @name hasWaitlistSpace
    * @methodOf BB.Models:Event
    * @description
    * Checks if this considered a valid waiting list space
    *
    * @returns {boolean} If this is a valid waiting list space
    */
    hasWaitlistSpace() {
      return ((this.getSpacesLeft() <= 0) && (this.getChain().waitlength > this.spaces_wait));
    }

    /***
    * @ngdoc method
    * @name getRemainingDescription
    * @methodOf BB.Models:Event
    * @description
    * Get the remaining description
    *
    * @returns {object} The returned remaining description
    */
    getRemainingDescription() {
      let left = this.getSpacesLeft();
      if ((left > 0) && (left < 3)) {
        return $translate.instant("CORE.EVENT.SPACES_LEFT", {N: left}, 'messageformat');
      }
      if (this.hasWaitlistSpace()) {
        return $translate.instant("CORE.EVENT.JOIN_WAITLIST");
      }
      return "";
    }

    /***
    * @ngdoc method
    * @name select
    * @methodOf BB.Models:Event
    * @description
    * Checks is this considered a selected
    *
    * @returns {boolean} If this is a selected
    */
    select() {
      return this.selected = true;
    }


    /***
    * @ngdoc method
    * @name unselect
    * @methodOf BB.Models:Event
    * @description
    * Unselect if is selected
    *
    * @returns {boolean} If this is a unselected
    */
    unselect() {
      if (this.selected) { return delete this.selected; }
    }

    /***
    * @ngdoc method
    * @name prepEvent
    * @methodOf BB.Models:Event
    * @description
    * Prepare the event
    *
    * @returns {promise} A promise for the event
    */
    prepEvent(params) {
      // build out some useful event stuff
      let def = $q.defer();
      this.getChain(params).then(() => {

        if (this.chain.$has('address')) {
          this.chain.$getAddress().then(address => {
            return this.chain.address = address;
          }
          );
        }

        return this.chain.getTickets().then(tickets => {
          this.tickets = tickets;

          this.price_range = {};
          if (tickets && (tickets.length > 0)) {
            for (let ticket of Array.from(this.tickets)) {
              if (!this.price_range.from || (this.price_range.from && (ticket.price < this.price_range.from))) { this.price_range.from = ticket.price; }
              if (!this.price_range.to || (this.price_range.to && (ticket.price > this.price_range.to))) { this.price_range.to = ticket.price; }
              ticket.old_price = ticket.price;
            }
          } else {
            this.price_range.from  = this.price;
            this.price_range.to = this.price;
          }

          this.ticket_prices = _.indexBy(tickets, 'name');

          return def.resolve(this);
        }
        );
      }
      );
      return def.promise;
    }

    /***
    * @ngdoc method
    * @name updatePrice
    * @methodOf BB.Models:Event
    * @description
    * Update price for the ticket
    *
    * @returns {object} The returned update price
    */
    updatePrice() {
      return Array.from(this.tickets).map((ticket) =>
        ticket.pre_paid_booking_id ?
          ticket.price = 0
        :
          ticket.price = ticket.old_price);
    }

    static $query(company, params) {
      return EventService.query(company, params);
    }

    static $summary(company, params) {
      return EventService.summary(company, params);
    }

    /***
    * @ngdoc method
    * @name numTicketsSelected
    * @methodOf BB.Models:Event
    * @description
    *
    *
    * @returns {object} get number of tickets selected
    */
    numTicketsSelected() {
      let num = 0;
      for (let ticket of Array.from(this.tickets)) {
        num += ticket.qty;
      }
      return num;
    }
  }
);

