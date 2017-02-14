// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("ItemDetailsService", ($q, BBModel) =>

    ({
        query(prms) {
            let deferred = $q.defer();
            if (prms.cItem.service) {
                if (!prms.cItem.service.$has('questions')) {
                    deferred.resolve(new BBModel.ItemDetails());
                } else {
                    prms.cItem.service.$get('questions').then(details => {
                            return deferred.resolve(new BBModel.ItemDetails(details));
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
            } else if (prms.cItem.event_chain) {
                if (!prms.cItem.event_chain.$has('questions')) {
                    deferred.resolve(new BBModel.ItemDetails());
                } else {
                    prms.cItem.event_chain.$get('questions').then(details => {
                            return deferred.resolve(new BBModel.ItemDetails(details));
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
            } else if (prms.cItem.deal) {
                if (!prms.cItem.deal.$has('questions')) {
                    deferred.resolve(new BBModel.ItemDetails());
                } else {
                    prms.cItem.deal.$get('questions').then(details => {
                            return deferred.resolve(new BBModel.ItemDetails(details));
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
            } else {
                deferred.resolve();
            }
            return deferred.promise;
        }
    })
);

