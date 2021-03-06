angular.module('BBAdminEvents').factory('AdminEventGroupService', ($q, BBModel) => {

        return {
            query(params) {
                let {company} = params;
                let defer = $q.defer();
                company.$get('event_groups').then(collection =>
                        collection.$get('event_groups').then(function (event_groups) {
                                let models = (Array.from(event_groups).map((e) => new BBModel.Admin.EventGroup(e)));
                                return defer.resolve(models);
                            }
                            , err => defer.reject(err))

                    , err => defer.reject(err));
                return defer.promise;
            }
        };
    }
);

