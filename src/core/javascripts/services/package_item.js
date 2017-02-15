// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("PackageItemService", ($q, BBModel) => {

        return {
            query(company) {
                let deferred = $q.defer();
                if (!company.$has('packages')) {
                    deferred.reject("No packages found");
                } else {
                    company.$get('packages').then(resource =>
                            resource.$get('packages').then(package_items => deferred.resolve(Array.from(package_items).map((i) => new BBModel.PackageItem(i))))

                        , err => deferred.reject(err));
                }
                return deferred.promise;
            },

            getPackageServices(package_item) {
                let deferred = $q.defer();
                if (!package_item.$has('services')) {
                    deferred.reject("No services found");
                } else {
                    package_item.$get('services').then(services => deferred.resolve((Array.from(services).map((s) => new BBModel.Service(s))))
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

