// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("SlotService", ($q, BBModel) =>

  ({
    query(company, params) {
      let deferred = $q.defer();
      if (!company.$has('slots')) {
        deferred.resolve([]);
      } else {
        if (params.item) {
          if (params.item.resource) { params.resource_id = params.item.resource.id; }
          if (params.item.person) { params.person_id = params.item.person.id; }
        }
        company.$get('slots', params).then(resource => {
          return resource.$get('slots', params).then(slots => {
            slots = (Array.from(slots).map((slot) => new BBModel.Slot(slot)));
            return deferred.resolve(slots);
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

