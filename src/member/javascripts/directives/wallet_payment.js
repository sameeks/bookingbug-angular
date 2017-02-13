// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BB.Directives").directive("bbWalletPayment", ($sce, $rootScope,
  $window, $location, GeneralOptions, AlertService) =>

  ({
    restrict: 'A',
    controller: 'Wallet',
    scope: true,
    replace: true,
    require: '^?bbWallet',
    link(scope, element, attrs, ctrl) {

      let one_pound = 100;
      scope.wallet_payment_options = scope.$eval(attrs.bbWalletPayment) || {};
      scope.member = scope.$eval(attrs.member);
      if ($rootScope.member) { if (!scope.member) { scope.member = $rootScope.member; } }
      if (scope.wallet_payment_options.member) { if (!scope.member) { scope.member = scope.wallet_payment_options.member; } }
      scope.amount_increment = scope.wallet_payment_options.amount_increment || one_pound;

      let getHost = function(url) {
        let a = document.createElement('a');
        a.href = url;
        return a['protocol'] + '//' +a['host'];
      };


      let sendLoadEvent = function(element, origin, scope) {
        let referrer = $location.protocol() + "://" + $location.host();
        if ($location.port()) {
          referrer += `:${$location.port()}`;
        }

        let custom_stylesheet = scope.wallet_payment_options.custom_stylesheet ? scope.wallet_payment_options.custom_stylesheet : null;
        let custom_partial_url = scope.bb && scope.bb.custom_partial_url ? scope.bb.custom_partial_url : null;

        let payload = JSON.stringify({
          'type': 'load',
          'message': referrer,
          'custom_partial_url': custom_partial_url,
          'custom_stylesheet' : custom_stylesheet,
          'scroll_offset'     : GeneralOptions.scroll_offset
        });
        return element.find('iframe')[0].contentWindow.postMessage(payload, origin);
      };


      let calculateAmount = function() {
        // if this is a basket topup, use either the amount due or the min topup amount, whichever is greatest

        if (scope.wallet_payment_options.basket_topup) {

          let amount_due = scope.bb.basket.dueTotal() - scope.wallet.amount;

          if (amount_due > scope.wallet.min_amount) {
            scope.amount = Math.ceil(amount_due / scope.amount_increment ) * scope.amount_increment;
          } else {
            scope.amount = scope.wallet.min_amount;
          }

          return scope.min_amount = scope.amount;

        } else if (scope.wallet.min_amount) {
          scope.amount     = scope.wallet_payment_options.amount && (scope.wallet_payment_options.amount > scope.wallet.min_amount) ? scope.wallet_payment_options.amount : scope.wallet.min_amount;
          return scope.min_amount = scope.wallet.min_amount;
        } else {
          scope.min_amount = 0;
          if (scope.wallet_payment_options.amount) { return scope.amount = scope.wallet_payment_options.amount; }
        }
      };


      // wait for wallet to be loaded by bbWallet or by self
      $rootScope.connection_started.then(function() {
        if (ctrl) {
          let deregisterWatch;
          return deregisterWatch = scope.$watch('wallet', function() {
            if (scope.wallet) {
              calculateAmount();
              return deregisterWatch();
            }
          });
        } else {
          return scope.getWalletForMember(scope.member).then(() => calculateAmount());
        }
      });


      // listen to when the wallet is updated
      scope.$on('wallet:updated', function(event, wallet, band) {

        // load iframe using payment link
        if (band == null) { band = null; }
        if (wallet.$has('new_payment')) {
          scope.notLoaded(scope);
          if (band) {
            scope.amount = band.actual_amount;
          }
          scope.wallet_payment_url = $sce.trustAsResourceUrl(wallet.$href("new_payment"));
          scope.show_payment_iframe = true;
          return element.find('iframe').bind('load', event => {
            let url;
            if (scope.wallet_payment_url) { url = scope.wallet_payment_url; }
            let origin = getHost(url);
            sendLoadEvent(element, origin, scope);
            return scope.$apply(() => scope.setLoaded(scope));
          }
          );
        }
      });


      // register iframe message listener
      return $window.addEventListener('message', event => {
        let data;
        if (angular.isObject(event.data)) {
          ({ data } = event);
        } else if (!event.data.match(/iFrameSizer/)) {
          data = JSON.parse(event.data);
        }
        return scope.$apply(() => {
          if (data) {
            switch (data.type) {
              case "submitting":
                return scope.notLoaded(scope);
              case "error":
                $rootScope.$broadcast("wallet:topup_failed");
                scope.notLoaded(scope);
                // reload the payment iframe
                document.getElementsByTagName("iframe")[0].src += '';
                return AlertService.raise('PAYMENT_FAILED');
              case "payment_complete": case "wallet_payment_complete": case "basket_wallet_payment_complete":
                scope.show_payment_iframe = false;
                if (scope.wallet_payment_options.basket_topup) {
                  return scope.basketWalletPaymentDone();
                } else {
                  return scope.walletPaymentDone();
                }
            }
          }
        }
        );
      }
      , false);
    }
  })
);

