angular.module('BBMember').directive 'bbWalletLogs', ($rootScope) ->

  link = (scope, element, attrs) ->

    getWalletLogsForWallet = () ->
      scope.getWalletLogs(scope.wallet)

    scope.$watch 'wallet', (wallet) ->
      if wallet?
        getWalletLogsForWallet()

  {
    link: link
    controller: 'Wallet'
    templateUrl: 'wallet_logs.html'
    scope:
      wallet: '='
  }