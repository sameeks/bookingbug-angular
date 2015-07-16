angular.module("BBMember").controller "Wallet", ($scope, $q, WalletService, $log, $modal) ->

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
      params = {amount: amount}
      params.total_id = $scope.total.id if $scope.total
      param.deposit = $scope.deposit if $scope.deposit
      WalletService.updateWalletForMember(member, params).then (wallet) ->
        $scope.wallet = wallet
      , (err) ->
        $log.error err.data

  buildPaymentUrl = (wallet) ->
    a = document.createElement('a')
    a.href = wallet.$href("new_payment")
    url = a.protocol + "//" + a.host + "/api/v1" + a.pathname + a.search
    url

  $scope.makePayment = (wallet) ->
    modalInstance = $modal.open
      title: "Make Payment"
      templateUrl: "wallet_payment.html"
      windowClass: "bbug"
      controller: ($modalInstance, $scope) ->
        $scope.controller = "MakePaymentModal"
        $scope.wallet = wallet
        $scope.url = buildPaymentUrl(wallet)
        $scope.confirmPayment = () ->
          $modalInstance.close(wallet)

        $scope.cancel = () ->
          $modalInstance.dismiss "cancel"

    modalInstance.result.then (wallet) ->
      $scope.wallet = wallet


