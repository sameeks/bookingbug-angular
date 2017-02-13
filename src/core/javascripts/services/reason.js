angular.module('BB.Services').factory("ReasonService", ($q, BBModel) =>
  ({
    query(company) {
      let deferred = $q.defer();
      if (!company.$has('reasons')) {
        deferred.reject("Reasons not turned on for this Company.");
      } else {
        company.$get('reasons').then(resource => {
          return resource.$get('reasons').then(items => {
            let reasons = [];
            for (let i of Array.from(items)) {
              let reason = new BBModel.Reason(i);
              reasons.push(reason);
            }
            return deferred.resolve(reasons);
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
