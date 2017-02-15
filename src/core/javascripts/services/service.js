// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("ServiceService", ($q, BBModel) => {

        return {
            query(company) {
                let deferred = $q.defer();
                if (!company.$has('services')) {
                    deferred.reject("No services found");
                } else {
                    company.$get('services').then(resource => {
                            return resource.$get('services').then(items => {
                                    let services = [];
                                    for (let i of Array.from(items)) {
                                        services.push(new BBModel.Service(i));
                                    }
                                    return deferred.resolve(services);
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

