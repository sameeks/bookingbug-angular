angular.module("BBMember").controller "Wallet", ($scope, $q, WalletService, $log, $modal, $rootScope, AlertService) ->
  

  $scope.getWalletForMember = (member, params) ->
    $scope.notLoaded $scope
    WalletService.getWalletForMember(member, params).then (wallet) ->
      $scope.setLoaded $scope
      $scope.wallet = wallet
    , (err) ->
      $scope.setLoaded $scope
      $log.error err


  $scope.getWalletLogs = (wallet) ->
    defer = $q.defer()
    $scope.notLoaded $scope
    WalletService.getWalletLogs($scope.wallet).then (logs) ->
      logs = _.sortBy(logs, (log) -> -moment(log.created_at).unix())
      $scope.setLoaded $scope
      $scope.logs = logs
      defer.resolve(logs)
    , (err) ->
      $scope.setLoaded $scope
      $log.error err.data
      defer.reject([])
    return defer.promise

  $scope.getWalletPurchaseBandsForWallet = (wallet) ->
    defer = $q.defer()
    $scope.notLoaded $scope
    WalletService.getWalletPurchaseBandsForWallet(wallet).then (bands) ->
      $scope.bands = bands
      $scope.setLoaded $scope
      defer.resolve(bands)
    , (err) ->
      $scope.setLoaded $scope
      $log.error err.data
      defer.reject([])
    return defer.promise



  $scope.createWalletForMember = (member) ->
    $scope.notLoaded $scope
    WalletService.createWalletForMember(member).then (wallet) ->
      $scope.setLoaded $scope
      $scope.wallet = wallet
    , (err) ->
      $scope.setLoaded $scope
      $log.error err.data

  
  $scope.updateWallet = (member, amount, band = null) ->
    $scope.notLoaded $scope
    if member and amount
      params = {}
      params.amount = amount if amount > 0
      params.wallet_id = $scope.wallet.id if $scope.wallet
      params.total_id = $scope.total.id if $scope.total
      params.deposit = $scope.deposit if $scope.deposit
      params.basket_total_price = $scope.basket.total_price if $scope.basket
      params.band_id = band.id if band
      WalletService.updateWalletForMember(member, params).then (wallet) ->
        $scope.setLoaded $scope
        $scope.wallet = wallet
      , (err) ->
        $scope.setLoaded $scope
        $log.error err.data


  $scope.activateWallet = (member) ->
    $scope.notLoaded $scope
    if member
      params = {status: 1}
      params.wallet_id = $scope.wallet.id if $scope.wallet
      WalletService.updateWalletForMember(member, params).then (wallet) ->
        $scope.setLoaded $scope
        $scope.wallet = wallet
      , (err) ->
        $scope.setLoaded $scope
        $log.error err.date


  $scope.deactivateWallet = (member) ->
    $scope.notLoaded $scope
    if member
      params = {status: 0}
      params.wallet_id = $scope.wallet.id if $scope.wallet
      WalletService.updateWalletForMember(member, params).then (wallet) ->
        $scope.setLoaded $scope
        $scope.wallet = wallet
      , (err) ->
        $scope.setLoaded $scope
        $log.error err.date
  
  $scope.purchaseBand = (band) ->
    $scope.selected_band = band
    $scope.updateWallet($scope.member, 0, band)

  $scope.walletPaymentDone = () ->
    $scope.getWalletForMember($scope.member).then (wallet) ->
      $scope.wallet = wallet
      AlertService.raise('TOPUP_SUCCESS')
      $scope.$emit("wallet:topped_up")
      

  # TODO don't route to next page automatically, first alert user 
  # topup was successful then show the 'next' button
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
