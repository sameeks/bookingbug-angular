// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue.Services').factory('AdminQueueService', ($q, BBModel) =>

    ({
        query(prms) {
            let deferred = $q.defer();
            prms.company.$get('client_queues').then(collection =>
                    collection.$get('client_queues').then(function (client_queues) {
                            let models = (Array.from(client_queues).map((q) => new BBModel.Admin.ClientQueue(q)));
                            return deferred.resolve(models);
                        }
                        , err => deferred.reject(err))

                , err => deferred.reject(err));
            return deferred.promise;
        }
    })
);

