// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("PersonService", ($q, BBModel) =>

  ({
    query(company) {
      let deferred = $q.defer();
      if (!company.$has('people')) {
        deferred.reject("No people found");
      } else {
        company.$get('people').then(resource => {
          return resource.$get('people').then(items => {
            let people = [];
            for (let i of Array.from(items)) {
              people.push(new BBModel.Person(i));
            }
            return deferred.resolve(people);
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

