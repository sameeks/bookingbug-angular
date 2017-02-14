// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("SpaceService", ($q, BBModel) =>

    ({
        query(company) {
            let deferred = $q.defer();
            if (!company.$has('spaces')) {
                deferred.reject("No spaces found");
            } else {
                company.$get('spaces').then(resource => {
                        return resource.$get('spaces').then(items => {
                                let spaces = [];
                                for (let i of Array.from(items)) {
                                    spaces.push(new BBModel.Space(i));
                                }
                                return deferred.resolve(spaces);
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
    })
);

