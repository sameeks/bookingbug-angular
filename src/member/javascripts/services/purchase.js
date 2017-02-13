angular.module('BBMember.Services').factory("MemberPurchaseService", ($q, $rootScope, BBModel) =>

  ({
    query(member, params) {
      if (!params) { params = {}; }
      params.no_cache = true;
      let deferred = $q.defer();
      if (!member.$has('purchase_totals')) {
        deferred.reject("member does not have any purchases");
      } else {
        member.$get('purchase_totals', params).then(purchases => {
          params.no_cache = false;
          return purchases.$get('purchase_totals', params).then(purchases => {
            purchases = Array.from(purchases).map((purchase) =>
              new BBModel.PurchaseTotal(purchase));
            return deferred.resolve(purchases);
          }
          , function(err) {
            if (err.status === 404) {
              return deferred.resolve([]);
            } else {
              return deferred.reject(err);
            }
          });
        }
        , function(err) {
          if (err.status === 404) {
            return deferred.resolve([]);
          } else {
            return deferred.reject(err);
          }
        });
      }
      return deferred.promise;
    }
  })
);
