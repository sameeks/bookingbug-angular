angular.module('BBMember.Services').factory "MemberPurchaseService", ($q, $rootScope, BBModel) ->

  query: (member, params) ->
    params ||= {}
     # TODO - need to find a a means to specify that the collection should be not cached, but the individual totals should be
    params["no_cache"] = true
    deferred = $q.defer()
    if !member.$has('purchase_totals')
      deferred.reject("member does not have any purchases")
    else
      member.$get('purchase_totals', params).then (purchases) =>
        purchases.$get('purchase_totals', params).then (purchases) =>
          purchases = for purchase in purchases
            new BBModel.PurchaseTotal(purchase)
          deferred.resolve(purchases)
        , (err) ->
          deferred.reject(err)
      , (err) ->
        deferred.reject(err)
    deferred.promise
