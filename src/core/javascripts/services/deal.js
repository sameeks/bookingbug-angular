// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("DealService", ($q, BBModel) => {

        return {
            query(company) {
                let deferred = $q.defer();
                if (!company.$has('deals')) {
                    deferred.reject("No Deals found");
                } else {
                    company.$get('deals').then(resource => {
                            return resource.$get('deals').then(deals => {
                                    deals = (Array.from(deals).map((deal) => new BBModel.Deal(deal)));
                                    return deferred.resolve(deals);
                                }
                            );
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

