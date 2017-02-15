angular.module('BB.Services').factory('TimeSlotService', ($q, BBModel) => {

        return {
            query(params) {
                let defer = $q.defer();
                let {company} = params;
                company.$get('slots', params).then(collection =>
                        collection.$get('slots').then(function (slots) {
                                slots = (Array.from(slots).map((s) => new BBModel.TimeSlot(s)));
                                return defer.resolve(slots);
                            }
                            , err => defer.reject(err))

                    , err => defer.reject(err));
                return defer.promise;
            }
        };
    }
);

