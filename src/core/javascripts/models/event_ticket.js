// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Models:EventTicket
 *
 * @description
 * Representation of an EventTicket Object
 *
 * @property {integer} max The maximum of the event ticket
 * @property {integer} max_num_bookings The maximum number of the bookings
 * @property {integer} max_spaces The maximum spaces of the evenet
 * @property {integer} counts_as The counts as
 * @property {string} pool_name The pool name
 * @property {string} name The name
 * @property {string} min_num_bookings The minimum number of the bookings
 * @property {string} qty The quantity of the event ticket
 * @property {string} totalQty The total quantity of the event ticket
 *///


angular.module('BB.Models').factory("EventTicketModel", ($q, BBModel, BaseModel) =>

    class EventTicket extends BaseModel {


        constructor(data) {
            super(data);

            this.max = this.max_num_bookings;

            // max_spaces is the total number of spaces reported by the event chain
            // adjust max if total spaces is less than max_num_bookings
            if (this.max_spaces) {
                let ms = this.max_spaces;
                // count_as defines the number of spaces a ticket uses
                if (this.counts_as) {
                    ms = this.max_spaces / this.counts_as;
                }
                if (ms < max) {
                    this.max = ms;
                }
            }
        }


        /***
         * @ngdoc method
         * @name fullName
         * @methodOf BB.Models:EventTicket
         * @description
         * Get the full name
         *
         * @returns {object} The returned full name
         */
        fullName() {
            if (this.pool_name) {
                return this.pool_name + " - " + this.name;
            }
            return this.name;
        }


        /***
         * @ngdoc method
         * @name getRange
         * @methodOf BB.Models:EventTicket
         * @description
         * Get the range between minimum number of bookings and the maximum number of bookings
         *
         * @returns {array} The returned range
         */
        getRange(event, cap) {

            if (!event) {
                return;
            }

            // if not simple ticket, pass pool id to event methods
            let pool = null;
            if (this.ticket_set) {
                pool = this.pool_id;
            }

            let max = this.getMax(event, pool, cap);
            let min = max <= this.min_num_bookings ? max : this.min_num_bookings;

            return [].concat(__range__(min, max, true));
        }


        /***
         * @ngdoc method
         * @name getMax
         * @methodOf BB.Models:EventTicket
         * @description
         * Get the maximum - this looks at an optional cap, the maximum available and potential a running count of tickets already selected (from passing in the event being booked)
         *
         * @returns {Integer} The max number of tickets that can be selected
         */
        getMax(ev, pool, cap) {

            let spaces_left, wait_spaces;
            if (pool == null) {
                pool = null;
            }
            if (cap == null) {
                cap = null;
            }
            let isAvailable = function (event) {
                _.each(event.ticket_spaces, function (ts) {
                    if (ts.left <= 0) {
                        return false;
                    }
                });
                return true;
            };

            if (!ev) {
                return 0;
            }

            // only show wait spaces if no spaces available in any pool
            if (!isAvailable(ev) || (ev.getSpacesLeft() <= 0)) {
                spaces_left = ev.getWaitSpacesLeft();
                wait_spaces = true;
            } else {
                spaces_left = ev.getSpacesLeft(pool);
            }

            let live_max = spaces_left <= this.max ? spaces_left : this.max;

            let used = 0;

            // count number of spaces used across the same ticket pool (except when spaces_left are waitlist ones)
            for (let ticket of Array.from(ev.tickets)) {
                if ((ticket.pool_id === this.pool_id) || wait_spaces) {
                    used += ticket.totalQty();
                }
            }

            // subtract self from used space count
            if (this.qty) {
                used = used - this.totalQty();
            }

            // adjust number of spaces used by count_as
            if (this.counts_as) {
                used = Math.ceil(used / this.counts_as);
            }

            live_max = live_max - used;
            if (live_max < 0) {
                live_max = 0;
            }

            var left = left - used;
            if (left < 0) {
                left = 0;
            }

            // use ticket cap if set
            if (this.cap) {
                ({cap} = this);
            }

            if (!cap || (cap > left)) {
                cap = left;
            }

            // adjust max by cap if it's lower
            if (cap) {
                let c = cap;
                if (this.counts_as) {
                    c = cap / this.counts_as;
                }
                if (c < live_max) {
                    return c;
                }
            }

            return live_max;
        }


        /***
         * @ngdoc method
         * @name totalQty
         * @methodOf BB.Models:EventTicket
         * @description
         * Get the total quantity of the event ticket
         *
         * @returns {array} The returned total quantity
         */
        totalQty() {
            if (!this.qty) {
                return 0;
            }
            if (!this.counts_as) {
                return this.qty;
            }
            return this.qty * this.counts_as;
        }


        /***
         * @ngdoc method
         * @name add
         * @methodOf BB.Models:EventTicket
         * @description
         * Add to the a quantity a new value
         *
         * @returns {array} The returned new quantity added
         */
        add(value) {
            if (!this.qty) {
                this.qty = 0;
            }
            this.qty = parseInt(this.qty);

            if ((angular.isNumber(this.qty) && ((this.qty >= this.max) && (value > 0))) || ((this.qty === 0) && (value < 0))) {
                return;
            }
            return this.qty += value;
        }


        /***
         * @ngdoc method
         * @name subtract
         * @methodOf BB.Models:EventTicket
         * @description
         * Subtract a value from the quantity
         *
         * @returns {array} The returned substract
         */
        subtract(value) {
            return this.add(-value);
        }
    }
);


function __range__(left, right, inclusive) {
    let range = [];
    let ascending = left < right;
    let end = !inclusive ? right : ascending ? right + 1 : right - 1;
    for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
        range.push(i);
    }
    return range;
}
