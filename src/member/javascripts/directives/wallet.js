angular.module('BBMember').directive('bbWallet', $rootScope =>

  ({
    scope: true,
    controller: 'Wallet',
    templateUrl: 'wallet.html',
    link(scope, element, attrs) {

      scope.member = scope.$eval(attrs.member);
      if ($rootScope.member) { if (!scope.member) { scope.member = $rootScope.member; } }

      scope.show_wallet_logs = true;
      scope.show_topup_box   = false;


      $rootScope.connection_started.then(function() {
        if (scope.member) { return scope.getWalletForMember(scope.member); }
      });


      scope.$on('wallet:topped_up', function(event, wallet) {
        scope.wallet           = wallet;
        scope.show_topup_box   = false;
        return scope.show_wallet_logs = true;
      });


      return scope.$on("booking:cancelled", function(event) {
        if (scope.member) { return scope.getWalletForMember(scope.member); }
      });
    }
  })
);

