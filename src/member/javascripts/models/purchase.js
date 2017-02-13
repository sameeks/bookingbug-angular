// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BB.Models").factory("Member.PurchaseModel", ($q,
  MemberPurchaseService, BBModel, BaseModel) =>

  class Member_Purchase extends BaseModel {

    constructor(data) {
      super(data);

      this.created_at = moment.parseZone(this.created_at);
      if (this.time_zone) { this.created_at.tz(this.time_zone); }
    }

    getItems() {
      let deferred = $q.defer();
      this._data.$get('purchase_items').then(function(items) {
        this.items = Array.from(items).map((item) =>
          new BBModel.Member.PurchaseItem(item));
        return deferred.resolve(this.items);
      });
      return deferred.promise;
    }

    static $query(member, params) {
      return MemberPurchaseService.query(member, params);
    }
  }
);
