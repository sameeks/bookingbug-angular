// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('AdminServiceService', ($q, BBModel, $log) =>

    ({
        query(params) {
            let {company} = params;
            let defer = $q.defer();
            company.$get('services').then(collection =>
                    collection.$get('services').then(function (services) {
                            let models = (Array.from(services).map((s) => new BBModel.Admin.Service(s)));
                            return defer.resolve(models);
                        }
                        , err => defer.reject(err))

                , err => defer.reject(err));
            return defer.promise;
        }
    })
);

