angular.module('BB.Services').factory "MemberPurchaseService",
($q, $rootScope, BBModel) ->

  query: (member, params) ->
    params ||= {}
    params["no_cache"] = true
    deferred = $q.defer()
    if !member.$has('purchase_totals')
      deferred.reject("member does not have any purchases")
    else
      member.$get('purchase_totals', params).then (purchases) =>
        purchases.$get('purchase_totals', params).then (purchases) =>
          purchases = for purchase in purchases
            new BBModel.Member.Purchase(purchase)
          deferred.resolve(purchases)
        , (err) ->
          deferred.reject(err)
      , (err) ->
        deferred.reject(err)
    deferred.promise
