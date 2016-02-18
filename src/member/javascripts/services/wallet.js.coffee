angular.module("BB.Services").factory "WalletService",
($q, BBModel) ->

  getWalletForMember: (member, params) ->
    params ||= {}
    params["no_cache"] = true
    deferred = $q.defer()
    if !member.$has("wallet")
      deferred.reject("Wallets are not turned on.")
    else
      member.$get("wallet", params).then (wallet) ->
        wallet = new BBModel.Member.Wallet(wallet)
        deferred.resolve(wallet)
      , (err) ->
        deferred.reject(err)
    deferred.promise

  getWalletLogs: (wallet) ->
    params = {no_cache: true}
    deferred = $q.defer()
    if !wallet.$has('logs')
      deferred.reject("No wallet transactions found")
    else
      wallet.$get('logs', params).then (resource) ->
        resource.$get('logs').then (logs) ->
          logs = (new BBModel.Member.WalletLog(log) for log in logs)
          deferred.resolve(logs)
      , (err) =>
        deferred.reject(err)

    deferred.promise

  getWalletPurchaseBandsForWallet: (wallet) ->
    deferred = $q.defer()
    if !wallet.$has('purchase_bands')
      deferred.reject("No Purchase Bands")
    else
      wallet.$get("purchase_bands", {}).then (resource) ->
        resource.$get("purchase_bands").then (bands) ->
          bands = (new BBModel.Member.WalletPurchaseBand(band) for band in bands)
          deferred.resolve(bands)
      , (err) ->
        deferred.reject(err)
    deferred.promise

  updateWalletForMember: (member, params) ->
    deferred = $q.defer()
    if !member.$has("wallet")
      deferred.reject("Wallets are not turned on.")
    else
      member.$put("wallet", {}, params).then (wallet) ->
        wallet = new BBModel.Member.Wallet(wallet)
        deferred.resolve(wallet)
      , (err) ->
        deferred.reject(err)
    deferred.promise

  createWalletForMember: (member) ->
    deferred = $q.defer()
    params = {}
    if !member.$has("wallet")
      deferred.reject("Wallets are not turned on.")
    else
      member.$post("wallet", {}, params).then (wallet) ->
        wallet = new BBModel.Member.Wallet(wallet)
        deferred.resolve(wallet)
      , (err) ->
        deferred.reject(err)
    deferred.promise
