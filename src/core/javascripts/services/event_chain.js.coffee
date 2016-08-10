angular.module('BB.Services').factory "EventChainService",  ($q, BBModel) ->

  query: (company, params) ->
    deferred = $q.defer()
    if !company.$has('event_chains')
      deferred.reject("company does not have event_chains")
    else
      company.$get('event_chains', params).then (resource) =>
        resource.$get('event_chains', params).then (event_chains) =>
          event_chains = for event_chain in event_chains
            new BBModel.EventChain(event_chain)
          deferred.resolve(event_chains)
      , (err) =>
        deferred.reject(err)
    deferred.promise


  queryEventChainCollection: (company, params) ->
    deferred = $q.defer()
    if !company.$has('event_chains')
      deferred.resolve([])
    else
      company.$get('event_chains', params).then (resource) =>
        collection = new BBModel.EventChainCollection(resource)
        collection.promise.then (collection) ->
          deferred.resolve(collection)
      , (err) =>
        deferred.reject(err)
    deferred.promise