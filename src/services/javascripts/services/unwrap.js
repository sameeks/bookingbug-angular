angular.module('BBAdminServices').factory("BB.Service.schedule", ($q, BBModel) => {
        return {
            unwrap(resource) {
                return new BBModel.Admin.Schedule(resource);
            }
        };
    }
);


angular.module('BBAdminServices').factory("BB.Service.person", ($q, BBModel) => {
        return {
            unwrap(resource) {
                return new BBModel.Admin.Person(resource);
            }
        };
    }
);


angular.module('BBAdminServices').factory("BB.Service.people", ($q, BBModel) => {
        return {
            promise: true,
            unwrap(resource) {
                let deferred = $q.defer();
                resource.$get('people').then(items => {
                        let models = [];
                        for (let i of Array.from(items)) {
                            models.push(new BBModel.Admin.Person(i));
                        }
                        return deferred.resolve(models);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );

                return deferred.promise;
            }
        };
    }
);


angular.module('BBAdminServices').factory("BB.Service.resource", ($q, BBModel) => {
        return {
            unwrap(resource) {
                return new BBModel.Admin.Resource(resource);
            }
        };
    }
);


angular.module('BBAdminServices').factory("BB.Service.resources", ($q, BBModel) => {
        return {
            promise: true,
            unwrap(resource) {
                let deferred = $q.defer();
                resource.$get('resources').then(items => {
                        let models = [];
                        for (let i of Array.from(items)) {
                            models.push(new BBModel.Admin.Resource(i));
                        }
                        return deferred.resolve(models);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );

                return deferred.promise;
            }
        };
    }
);


angular.module('BBAdminServices').factory("BB.Service.service", ($q, BBModel) => {
        return {
            unwrap(resource) {
                return new BBModel.Admin.Service(resource);
            }
        };
    }
);


angular.module('BBAdminServices').factory("BB.Service.services", ($q, BBModel) => {
        return {
            promise: true,
            unwrap(resource) {
                let deferred = $q.defer();
                resource.$get('services').then(items => {
                        let models = [];
                        for (let i of Array.from(items)) {
                            models.push(new BBModel.Admin.Service(i));
                        }
                        return deferred.resolve(models);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );

                return deferred.promise;
            }
        };
    }
);
