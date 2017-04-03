angular.module('BBQueue.services').factory('AdminQueueService', ($q, BBModel) =>
({
    query(params) {
        let defer = $q.defer();
        params.company.$get('client_queues').then(collection =>
            collection.$get('client_queues').then(function(client_queues) {
                let models = (Array.from(client_queues).map((q) => new BBModel.Admin.ClientQueue(q)));
                return defer.resolve(models);
            }, err => defer.reject(err))
        , err => defer.reject(err));
        return defer.promise;
    }
}));
