// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("ClientDetailsService", ($q, BBModel) =>

    ({
        query(company) {
            let deferred = $q.defer();
            if (!company.$has('client_details')) {
                deferred.reject("No client_details found");
            } else {
                company.$get('client_details').then(details => {
                        return deferred.resolve(new BBModel.ClientDetails(details));
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );
            }
            return deferred.promise;
        }
    })
);

