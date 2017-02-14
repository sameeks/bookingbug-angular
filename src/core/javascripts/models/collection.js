// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("BBCollectionModel", ($q, BBModel, BaseModel) =>

    class BBCollection extends BaseModel {

        getNextPage(params) {

            let deferred = $q.defer();

            this.$get('next', params).then(collection => deferred.resolve(new BBModel.BBCollection(collection))
                , () => deferred.reject());

            return deferred.promise;
        }
    }
);

