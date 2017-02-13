// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("EventGroupService",  ($q, BBModel) =>

  ({
    query(company, params) {
      let deferred = $q.defer();
      if (!company.$has('event_groups')) {
        deferred.reject("company does not have event_groups");
      } else {
        company.$get('event_groups', params).then(resource => {
          return resource.$get('event_groups', params).then(event_groups => {
            event_groups = Array.from(event_groups).map((event_group) =>
              new BBModel.EventGroup(event_group));
            return deferred.resolve(event_groups);
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

