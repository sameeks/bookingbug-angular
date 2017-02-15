angular.module('BB.Services').factory("PurchaseTotalService", ($q, BBModel) => {

        return {
            query(prms) {
                let deferred = $q.defer();
                if (!prms.company.$has('total')) {
                    deferred.reject("No Total link found");
                } else {
                    prms.company.$get('total', {total_id: prms.total_id}).then(total => {
                            return deferred.resolve(new BBModel.PurchaseTotal(total));
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
                return deferred.promise;
            }
        };
    }
);

