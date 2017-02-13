angular.module('BBMember').directive('bbWalletLogs', ($rootScope, PaginationService) =>

  ({
    templateUrl: 'wallet_logs.html',
    scope: true,
    controller: 'Wallet',
    require: '^?bbWallet',
    link(scope, element, attrs, ctrl) {

      scope.member = scope.$eval(attrs.member);
      if ($rootScope.member) { if (!scope.member) { scope.member = $rootScope.member; } }

      scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5});


      let getWalletLogs = ()=>
        scope.getWalletLogs().then(logs => PaginationService.update(scope.pagination, logs.length))
      ;


      // listen to when the wallet is topped up
      scope.$on('wallet:topped_up', event => getWalletLogs());


      // wait for wallet to be loaded by bbWallet or by self
      return $rootScope.connection_started.then(function() {
        if (ctrl) {
          let deregisterWatch;
          return deregisterWatch = scope.$watch('wallet', function() {
            if (scope.wallet) {
              getWalletLogs();
              return deregisterWatch();
            }
          });
        } else {
          return scope.getWalletForMember(scope.member).then(() => getWalletLogs());
        }
      });
    }
  })
);

