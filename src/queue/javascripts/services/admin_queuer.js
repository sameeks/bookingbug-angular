// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue.Services').factory('AdminQueuerService', ($q, BBModel) => {

        return {
            query(params) {
                let defer = $q.defer();
                params.company.$flush('queuers');
                params.company.$get('queuers').then(collection =>
                        collection.$get('queuers').then(function (queuers) {
                                let models = (Array.from(queuers).map((q) => new BBModel.Admin.Queuer(q)));
                                return defer.resolve(models);
                            }
                            , err => defer.reject(err))

                    , err => defer.reject(err));
                return defer.promise;
            }
        };
    }
);

