angular.module("BBMember").controller "Wallet", ($scope, $rootScope, $q,
  $log, AlertService, LoadingService, BBModel) ->

  loader = LoadingService.$loader($scope)

  $scope.getWalletForMember = (member, params) ->
    defer = $q.defer()
    loader.notLoaded()
    BBModel.Member.Wallet.$getWalletForMember(member, params).then (wallet) ->
      loader.setLoaded()
      $scope.wallet = wallet
      updateClient(wallet)
      defer.resolve(wallet)
    , (err) ->
      loader.setLoaded()
      defer.reject()
    return defer.promise

  $scope.getWalletLogs = () ->
    defer = $q.defer()
    loader.notLoaded()
    BBModel.Member.Wallet.$getWalletLogs($scope.wallet).then (logs) ->
      logs = _.sortBy(logs, (log) -> -moment(log.created_at).unix())
      loader.setLoaded()
      $scope.logs = logs
      defer.resolve(logs)
    , (err) ->
      loader.setLoaded()
      $log.error err.data
      defer.reject([])
    return defer.promise

  $scope.getWalletPurchaseBandsForWallet = (wallet) ->
    defer = $q.defer()
    loader.notLoaded()
    BBModel.Member.Wallet.$getWalletPurchaseBandsForWallet(wallet).then (bands) ->
      $scope.bands = bands
      loader.setLoaded()
      defer.resolve(bands)
    , (err) ->
      loader.setLoaded()
      $log.error err.data
      defer.resolve([])
    return defer.promise

  $scope.createWalletForMember = (member) ->
    loader.notLoaded()
    BBModel.Member.Wallet.$createWalletForMember(member).then (wallet) ->
      loader.setLoaded()
      $scope.wallet = wallet
    , (err) ->
      loader.setLoaded()
      $log.error err.data

  $scope.updateWallet = (member, amount, band = null) ->
    loader.notLoaded()
    if member
      params = {}
      params.amount = amount if amount > 0
      params.wallet_id = $scope.wallet.id if $scope.wallet
      params.total_id = $scope.total.id if $scope.total
      params.deposit = $scope.deposit if $scope.deposit
      params.basket_total_price = $scope.basket.total_price if $scope.basket
      params.band_id = band.id if band
      BBModel.Member.Wallet.$updateWalletForMember(member, params).then (wallet) ->
        loader.setLoaded()
        $scope.wallet = wallet
        $rootScope.$broadcast("wallet:updated", wallet, band)
      , (err) ->
        loader.setLoaded()
        $log.error err.data

  $scope.activateWallet = (member) ->
    loader.notLoaded()
    if member
      params = {status: 1}
      params.wallet_id = $scope.wallet.id if $scope.wallet
      BBModel.Member.Wallet.$updateWalletForMember(member, params).then (wallet) ->
        loader.setLoaded()
        $scope.wallet = wallet
      , (err) ->
        loader.setLoaded()
        $log.error err.date

  $scope.deactivateWallet = (member) ->
    loader.notLoaded()
    if member
      params = {status: 0}
      params.wallet_id = $scope.wallet.id if $scope.wallet
      BBModel.Member.Wallet.$updateWalletForMember(member, params).then (wallet) ->
        loader.setLoaded()
        $scope.wallet = wallet
      , (err) ->
        loader.setLoaded()
        $log.error err.date

  $scope.purchaseBand = (band) ->
    $scope.selected_band = band
    $scope.updateWallet($scope.member, band.wallet_amount, band)

  $scope.walletPaymentDone = () ->
    $scope.getWalletForMember($scope.member).then (wallet) ->
      AlertService.raise('TOPUP_SUCCESS')
      $rootScope.$broadcast("wallet:topped_up", wallet)
      $scope.wallet_topped_up = true

  # TODO don't route to next page automatically, first alert user
  # topup was successful and show new wallet balance + the 'next' button
  $scope.basketWalletPaymentDone = () ->
    $scope.callSetLoaded()
    $scope.decideNextPage('checkout')

  $scope.error = (message) ->
    AlertService.warning('TOPUP_FAILED')

  $scope.add = (value) ->
    value = value or $scope.amount_increment
    $scope.amount += value

  $scope.subtract = (value) ->
    value = value or $scope.amount_increment
    $scope.add(-value)

  $scope.isSubtractValid = (value) ->
    return false if !$scope.wallet
    value = value or $scope.amount_increment
    new_amount = $scope.amount - value
    return new_amount >= $scope.wallet.min_amount

  updateClient = (wallet) ->
    if $scope.member.self is $scope.client.self
      $scope.client.wallet_amount = wallet.amount
