angular.module("BBMember").controller "Wallet", ($scope, $q, WalletService, $log) ->

  $scope.getWalletForMember = (member) ->
    WalletService.getWalletForMember(member).then (wallet) ->
      $scope.wallet = wallet
    , (err) ->
      $log.error err.data

  $scope.getWalletLogs = (wallet) ->
    WalletService.getWalletLogs($scope.wallet).then (logs) ->
      $scope.logs = logs
    , (err) ->
      $log.error err.data
  
  $scope.updateWallet = (member, amount) ->
    if member and amount
      params = {amount: (amount * 100)}
      params.total_id = $scope.total.id if $scope.total
      param.deposit = $scope.deposit if $scope.deposit
      WalletService.updateWalletForMember(member, params).then (wallet) ->
        console.log(wallet)
        console.log(wallet.$has('new_payment'))
        $scope.wallet = wallet
        # SHOULD RETURN A WALLET OBJECT WITH A PAYMENT LINK
        # THEN USING THE LINK RENDER AN IFRAME TO PAY
      , (err) ->
        $log.error err.data
