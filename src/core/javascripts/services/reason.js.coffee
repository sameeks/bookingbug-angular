angular.module('BB.Services').factory "ReasonService", ($q, BBModel) ->
  query: (company) ->
    deferred = $q.defer()
    if !company.$has('reasons')
      deferred.reject("Reasons not turned on for this Company.")
    else
      company.$get('reasons').then (resource) =>
        resource.$get('reasons').then (items) =>
          reasons = []
          for i in items
            reason = new BBModel.Reason(i)
            reasons.push(reason)
          deferred.resolve(reasons)
      , (err) =>
        deferred.reject(err)

    deferred.promise
