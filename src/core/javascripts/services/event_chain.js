// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("EventChainService",  ($q, BBModel) =>

  ({
    query(company, params) {
      let deferred = $q.defer();
      if (!company.$has('event_chains')) {
        deferred.reject("company does not have event_chains");
      } else {
        company.$get('event_chains', params).then(resource => {
          return resource.$get('event_chains', params).then(event_chains => {
            event_chains = Array.from(event_chains).map((event_chain) =>
              new BBModel.EventChain(event_chain));
            return deferred.resolve(event_chains);
          }
          );
        }
        , err => {
          return deferred.reject(err);
        }
        );
      }
      return deferred.promise;
    },


    queryEventChainCollection(company, params) {
      let deferred = $q.defer();
      if (!company.$has('event_chains')) {
        deferred.resolve([]);
      } else {
        company.$get('event_chains', params).then(resource => {
          let collection = new BBModel.BBCollection(resource);
          return deferred.resolve(collection);
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

