/***
 * @ngdoc service
 * @name BB.Models:PurchaseTotal
 *
 * @description
 * Representation of an PurchaseTotal Object
 *
 * @property {float} total_price The total price of items
 * @property {float} price Price of items
 * @property {float} tax_payable_on_price The tax payable on price of the item
 * @property {float} due_now The due now
 *///


angular.module('BB.Models').factory("PurchaseTotalModel", ($q, BBModel,
                                                           BaseModel, PurchaseService) =>

    class PurchaseTotal extends BaseModel {

        constructor(data) {
            super(data);
            this.promise = this._data.$get('purchase_items');
            this.purchase_items = [];
            this.promise.then(items => {
                    return Array.from(items).map((item) =>
                        this.purchase_items.push(new BBModel.PurchaseItem(item)));
                }
            );
            if (this._data.$has('client')) {
                let cprom = data.$get('client');
                cprom.then(client => {
                        return this.client = new BBModel.Client(client);
                    }
                );
            }
            this.created_at = moment.parseZone(this.created_at);
            if (this.time_zone) {
                this.created_at.tz(this.time_zone);
            }
        }


        /***
         * @ngdoc method
         * @name icalLink
         * @methodOf BB.Models:PurchaseTotal
         * @description
         * Get the icalLink
         *
         * @returns {object} The returned icalLink
         */
        icalLink() {
            return this._data.$href('ical');
        }

        /***
         * @ngdoc method
         * @name webcalLink
         * @methodOf BB.Models:PurchaseTotal
         * @description
         * Get webcalLink
         *
         * @returns {object} The returned webcalLink
         */
        webcalLink() {
            return this._data.$href('ical');
        }

        /***
         * @ngdoc method
         * @name gcalLink
         * @methodOf BB.Models:PurchaseTotal
         * @description
         * Get the gcalLink
         *
         * @returns {object} The returned gcalLink
         */
        gcalLink() {
            return this._data.$href('gcal');
        }

        /***
         * @ngdoc method
         * @name id
         * @methodOf BB.Models:PurchaseTotal
         * @description
         * Get the id
         *
         * @returns {object} The returned id
         */
        id() {
            return this.get('id');
        }

        static $query(params) {
            return PurchaseService.query((params));
        }

        static $bookingRefQuery(params) {
            return PurchaseService.query((params));
        }
    }
);

