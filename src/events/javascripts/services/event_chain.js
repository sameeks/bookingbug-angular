angular.module('BBAdminEvents').factory('AdminEventChainService', ($q, BBModel) => {

        return {
            query(params) {
                let {company} = params;
                let defer = $q.defer();
                company.$get('event_chains').then(collection =>
                        collection.$get('event_chains').then(function (event_chains) {
                                let models = (Array.from(event_chains).map((e) => new BBModel.Admin.EventChain(e)));
                                return defer.resolve(models);
                            }
                            , err => defer.reject(err))

                    , err => defer.reject(err));
                return defer.promise;
            }
        };
    }
);

