angular.module("BB.Directives").directive "bbWalletPayment", ($sce, $rootScope, $window, $location, SettingsService, AlertService) ->
  restrict: 'A'
  controller: 'Wallet'
  scope: true
  replace: true
  link: (scope, element, attrs) ->

    one_pound = 100
    scope.wallet_payment_options = scope.$eval(attrs.bbWalletPayment) or {}
    scope.member ||= $rootScope.member if $rootScope.member
    scope.member ||= scope.wallet_payment_options.member if scope.wallet_payment_options.member
    scope.amount_increment = scope.wallet_payment_options.amount_increment or one_pound

    getHost = (url) ->
      a = document.createElement('a')
      a.href = url
      a['protocol'] + '//' +a['host']


    sendLoadEvent = (element, origin, scope) ->
      referrer = $location.protocol() + "://" + $location.host()
      if $location.port()
        referrer += ":" + $location.port()
      
      custom_stylesheet = if scope.wallet_payment_options.custom_stylesheet then scope.wallet_payment_options.custom_stylesheet else null
      custom_partial_url = if scope.bb and scope.bb.custom_partial_url then scope.bb.custom_partial_url else null

      payload = JSON.stringify({
        'type': 'load',
        'message': referrer,
        'custom_partial_url': custom_partial_url,
        'custom_stylesheet' : custom_stylesheet,
        'scroll_offset'     : SettingsService.getScrollOffset()
      })
      element.find('iframe')[0].contentWindow.postMessage(payload, origin)


    getWalletForMember = () ->
      scope.getWalletForMember(scope.member, {})


    scope.$watch 'member', (member) ->
      if member?
        getWalletForMember()


    scope.$watch 'wallet', (wallet) ->
      
      if wallet and !scope.amount
        if scope.wallet_payment_options.basket_topup

          amount_due = scope.bb.basket.dueTotal() - wallet.amount
          
          if amount_due > wallet.min_amount
            scope.amount = Math.ceil(amount_due / scope.amount_increment ) * scope.amount_increment
          else
            scope.amount = wallet.min_amount

          scope.min_amount = scope.amount

        else if wallet.min_amount
          scope.amount     = if scope.wallet_payment_options.amount and scope.wallet_payment_options.amount > wallet.min_amount then scope.wallet_payment_options.amount else wallet.min_amount
          scope.min_amount = wallet.min_amount
        else
          scope.min_amount = 0
          scope.amount = scope.wallet_payment_options.amount if scope.wallet_payment_options.amount

      if wallet and wallet.$has('new_payment')
        scope.notLoaded scope
        scope.wallet_payment_url = $sce.trustAsResourceUrl(scope.wallet.$href("new_payment"))
        scope.show_payment_iframe = true
        element.find('iframe').bind 'load', (event) =>
          url = scope.wallet_payment_url if scope.wallet_payment_url
          origin = getHost(url)
          sendLoadEvent(element, origin, scope)
          scope.$apply ->
            scope.setLoaded scope

    # TODO update API to only respond with single message for wallet pay complete
    # scope.wallet_payment_options.basket_topup
    # API now raises payment_complete postMessage
    $window.addEventListener 'message', (event) =>
      if angular.isObject(event.data)
        data = event.data
      else if not event.data.match(/iFrameSizer/)
        data = JSON.parse event.data
      scope.$apply =>
        if data
          switch data.type
            when "submitting"
              scope.notLoaded scope
            when "error"
              scope.$emit "wallet:topup_failed"
              scope.notLoaded scope
              AlertService.raise('PAYMENT_FAILED')
              # reload the payment iframe
              document.getElementsByTagName("iframe")[0].src += ''
            when "wallet_payment_complete"
              scope.show_payment_iframe = false
              scope.walletPaymentDone()
            when 'basket_wallet_payment_complete'
              scope.show_payment_iframe = false
              scope.basketWalletPaymentDone()
    , false


