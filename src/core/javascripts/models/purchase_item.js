/***
* @ngdoc service
* @name BB.Models:PurchaseItem
*
* @description
* Representation of an PurchaseItem Object
*
* @property {float} price Price of the purchase item
* @property {float} paid Purchase item paid
*///


angular.module('BB.Models').factory("PurchaseItemModel", ($q, BBModel, BaseModel) =>

  class PurchaseItem extends BaseModel {

    constructor(data) {
      super(data);
      this.parts_links = {};
      if (data) {
        if (data.$has('service')) {
          this.parts_links.service = data.$href('service');
        }
        if (data.$has('resource')) {
          this.parts_links.resource = data.$href('resource');
        }
        if (data.$has('person')) {
          this.parts_links.person = data.$href('person');
        }
        if (data.$has('company')) {
          this.parts_links.company = data.$href('company');
        }
      }
    }

    /***
    * @ngdoc method
    * @name describe
    * @methodOf BB.Models:PurchaseItem
    * @description
    * Describe the item for purchase
    *
    * @returns {object} The returned describe
    */
    describe() {
      return this.get('describe');
    }

    /***
    * @ngdoc method
    * @name full_describe
    * @methodOf BB.Models:PurchaseItem
    * @description
    * Full description of the item purchase
    *
    * @returns {object} The returned full describe
    */
    full_describe() {
      return this.get('full_describe');
    }

    /***
    * @ngdoc method
    * @name hasPrice
    * @methodOf BB.Models:PurchaseItem
    * @description
    * Checks if the item for purchase have a price
    *
    * @returns {boolean} If the item for purchase have a price
    */
    hasPrice() {
      return (this.price && (this.price > 0));
    }
  }
);

