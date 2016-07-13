angular.module('BBMember').directive 'bbWalletLogs', ($rootScope, PaginationService) ->

  templateUrl: 'wallet_logs.html'
  scope: true
  controller: 'Wallet'
  require: '^?bbWallet'
  link: (scope, element, attrs, ctrl) ->

    scope.member = scope.$eval(attrs.member)
    scope.member ||= $rootScope.member if $rootScope.member

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})


    getWalletLogs = ()->
      scope.getWalletLogs().then (logs) ->
        PaginationService.update(scope.pagination, logs.length)


    # listen to when the wallet is topped up
    scope.$on 'wallet:topped_up', (event) ->
      getWalletLogs()


    # wait for wallet to be loaded by bbWallet or by self
    $rootScope.connection_started.then () ->
      if ctrl
        deregisterWatch = scope.$watch 'wallet', () ->
          if scope.wallet
            getWalletLogs()
            deregisterWatch()
      else
        scope.getWalletForMember(scope.member).then () ->
          getWalletLogs()

