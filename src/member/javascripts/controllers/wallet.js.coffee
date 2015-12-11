angular.module("BBMember").controller "Wallet", ($scope, $q, WalletService, $log, $modal, $rootScope, AlertService) ->
  

  $scope.getWalletForMember = (member, params) ->
    defer = $q.defer()
    $scope.notLoaded $scope
    WalletService.getWalletForMember(member, params).then (wallet) ->
      $scope.setLoaded $scope
      $scope.wallet = wallet
      updateClient(wallet)
      defer.resolve()
    , (err) ->
      $scope.setLoaded $scope
      defer.reject()
    return defer.promise


  $scope.getWalletLogs = () ->
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


  $scope.createWalletForMember = (member) ->
    $scope.notLoaded $scope
    WalletService.createWalletForMember(member).then (wallet) ->
      $scope.setLoaded $scope
      $scope.wallet = wallet
    , (err) ->
      $scope.setLoaded $scope
      $log.error err.data

  
  $scope.updateWallet = (member, amount) ->
    $scope.notLoaded $scope
    if member and amount
      params = {amount: amount}
      params.wallet_id = $scope.wallet.id if $scope.wallet
      params.total_id = $scope.total.id if $scope.total
      param.deposit = $scope.deposit if $scope.deposit
      params.basket_total_price = $scope.basket.total_price if $scope.basket
      WalletService.updateWalletForMember(member, params).then (wallet) ->
        $scope.setLoaded $scope
        $scope.wallet = wallet
        $rootScope.$broadcast("wallet:updated", wallet)
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
  

  $scope.walletPaymentDone = () ->
    $scope.getWalletForMember($scope.member).then () ->
      AlertService.raise('TOPUP_SUCCESS')
      $rootScope.$broadcast("wallet:topped_up", wallet)
      

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