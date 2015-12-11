angular.module('BBMember').directive 'bbWallet', ($rootScope) ->
  scope: true
  controller: 'Wallet'
  templateUrl: 'wallet.html'
  link: (scope, element, attrs) ->

    scope.member = scope.$eval(attrs.member)
    scope.member ||= $rootScope.member if $rootScope.member

    scope.show_wallet_logs = true
    scope.show_topup_box   = false
    

    $rootScope.connection_started.then () ->
      scope.getWalletForMember(scope.member) if scope.member


    scope.$on 'wallet:topped_up', (event, wallet) ->
      scope.wallet           = wallet
      scope.show_topup_box   = false
      scope.show_wallet_logs = true


    scope.$on "booking:cancelled", (event) ->
      scope.getWalletForMember(scope.member) if scope.member

