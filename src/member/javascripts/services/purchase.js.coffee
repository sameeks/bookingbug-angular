angular.module('BBMember.Services').factory "MemberPurchaseService", ($q, $rootScope, BBModel) ->

  query: (member, params) ->
    params ||= {}
    params.no_cache = true
    deferred = $q.defer()
    if !member.$has('purchase_totals')
      deferred.reject("member does not have any purchases")
    else
      member.$get('purchase_totals', params).then (purchases) =>
        params.no_cache = false
        purchases.$get('purchase_totals', params).then (purchases) =>
          purchases = for purchase in purchases
            new BBModel.PurchaseTotal(purchase)
          deferred.resolve(purchases)
        , (err) ->
          if err.status == 404
            deferred.resolve([])
          else
            deferred.reject(err)
      , (err) ->
        if err.status == 404
          deferred.resolve([])
        else
          deferred.reject(err)
    deferred.promise