// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("ResourceService", ($q, BBModel) =>

  ({
    query(company) {
      let deferred = $q.defer();
      if (!company.$has('resources')) {
        deferred.reject("No resource found");
      } else {
        company.$get('resources').then(resource => {
          return resource.$get('resources').then(items => {
            let resources = [];
            for (let i of Array.from(items)) {
              resources.push(new BBModel.Resource(i));
            }
            return deferred.resolve(resources);
          }
          );
        }
        , err => {
          return deferred.reject(err);
        }
        );
      }
      return deferred.promise;
    }
  })
);

