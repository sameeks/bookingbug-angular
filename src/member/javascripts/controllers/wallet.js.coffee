angular.module("BBMember").controller "Wallet", ($scope, $q, WalletService, $log, $modal, $rootScope, AlertService) ->
  
  $scope.company_id = $scope.member.company_id if $scope.member
  $scope.show_wallet_logs = false
  $scope.notLoaded $scope
  $scope.error_message = false
  $scope.payment_success = false


  $scope.toggleWalletPaymentLogs = () ->
    if $scope.show_wallet_logs 
      $scope.show_wallet_logs = false
    else
      $scope.show_wallet_logs = true


  $scope.showTopUpBox = () ->
    if $scope.amount
      true
    else 
      $scope.show_topup_box


  $scope.getWalletForMember = (member, params) ->
    $scope.notLoaded $scope
    WalletService.getWalletForMember(member, params).then (wallet) ->
      $scope.setLoaded $scope
      $scope.wallet = wallet
      $scope.wallet
    , (err) ->
      $scope.setLoaded $scope
      $log.error err


  $scope.getWalletLogs = (wallet) ->
    $scope.notLoaded $scope
    WalletService.getWalletLogs($scope.wallet).then (logs) ->
      $scope.setLoaded $scope
      $scope.logs = logs
    , (err) ->
      $scope.setLoaded $scope
      $log.error err.data


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
    $scope.payment_success = false
    $scope.error_message = false
    if member and amount
      params = {amount: amount}
      params.wallet_id = $scope.wallet.id if $scope.wallet
      params.total_id = $scope.total.id if $scope.total
      param.deposit = $scope.deposit if $scope.deposit
      params.basket_total_price = $scope.basket.total_price if $scope.basket
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
  

  $scope.callNotLoaded = () =>
    $scope.notLoaded $scope
    $scope.$emit('wallet_payment:loading')


  $scope.callSetLoaded = () =>
    $scope.setLoaded $scope
    $scope.$emit('wallet_payment:finished_loading')


  $scope.walletPaymentDone = () ->
    $scope.getWalletForMember($scope.member).then (wallet) ->
      $scope.$emit("wallet:topped_up", wallet)


  $scope.basketWalletPaymentDone = () ->
    scope.callSetLoaded()
    $scope.decideNextPage('checkout')


  $scope.error = (message) ->
    $scope.error_message = "Payment Failure: " + message
    $log.warn("Payment Failure: " + message)
    $scope.$emit("wallet_payment:error", $scope.error_message)
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
