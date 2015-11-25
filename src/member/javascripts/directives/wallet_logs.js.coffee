angular.module('BBMember').directive 'bbWalletLogs', ($rootScope, PaginationService) ->
  templateUrl: 'wallet_logs.html'
  scope: true
  controller: 'Wallet'
  link: (scope, element, attrs) ->

    scope.member = scope.$eval(attrs.member)
    scope.member ||= $rootScope.member if $rootScope.member

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})
    
    # watch for any updates to the wallet to ensure the log is up to date,
    # i.e. when the wallet is topped up
    scope.$watch 'wallet', (wallet) ->
      if wallet?
        scope.getWalletLogs(wallet).then (logs) ->
          PaginationService.update(scope.pagination, logs.length)


    $rootScope.connection_started.then () ->
      scope.getWalletForMember(scope.member) if scope.member