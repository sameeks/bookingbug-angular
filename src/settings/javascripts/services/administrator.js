// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('AdminAdministratorService', ($q, BBModel) => {

        return {
            query(params) {
                let {company} = params;
                let defer = $q.defer();
                company.$get('administrators').then(collection =>
                        collection.$get('administrators').then(function (administrators) {
                                let models = (Array.from(administrators).map((a) => new BBModel.Admin.Administrator(a)));
                                return defer.resolve(models);
                            }
                            , err => defer.reject(err))

                    , err => defer.reject(err));
                return defer.promise;
            }
        };
    }
);

