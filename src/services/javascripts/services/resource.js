angular.module('BBAdmin.Services').factory('AdminResourceService', ($q, UriTemplate, halClient, SlotCollections, BBModel, BookingCollections) => {

        return {
            query(params) {
                let {company} = params;
                let defer = $q.defer();
                company.$get('resources', params).then(collection =>
                        collection.$get('resources').then(function (resources) {
                                let models = (Array.from(resources).map((r) => new BBModel.Admin.Resource(r)));
                                return defer.resolve(models);
                            }
                            , err => defer.reject(err))

                    , err => defer.reject(err));
                return defer.promise;
            },

            block(company, resource, data) {
                let deferred = $q.defer();
                resource.$put('block', {}, data).then(response => {
                        if (response.$href('self').indexOf('bookings') > -1) {
                            let booking = new BBModel.Admin.Booking(response);
                            BookingCollections.checkItems(booking);
                            return deferred.resolve(booking);
                        } else {
                            let slot = new BBModel.Admin.Slot(response);
                            SlotCollections.checkItems(slot);
                            return deferred.resolve(slot);
                        }
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

