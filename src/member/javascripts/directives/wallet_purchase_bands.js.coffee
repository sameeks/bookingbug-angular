angular.module("BB.Directives").directive "bbWalletPurchaseBands", ($rootScope) ->
  scope: true
  restrict: "AE"
  templateUrl: "wallet_purchase_bands.html"
  controller: "Wallet"
  require: '^?bbWallet'
  link: (scope, attr, elem) ->

    $rootScope.connection_started.then () ->
      scope.getWalletPurchaseBandsForWallet(scope.wallet)
