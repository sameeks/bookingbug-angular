// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("BulkPurchaseService", ($q, BBModel) =>

  ({
    query(company) {
      let deferred = $q.defer();
      if (!company.$has('bulk_purchases')) {
        deferred.reject("No bulk purchases found");
      } else {
        company.$get('bulk_purchases').then(resource =>
          resource.$get('bulk_purchases').then(bulk_purchases => deferred.resolve(Array.from(bulk_purchases).map((i) => new BBModel.BulkPurchase(i))))
        
        , err => {
          return deferred.reject(err);
        }
        );
      }
      return deferred.promise;
    }
  })
);

