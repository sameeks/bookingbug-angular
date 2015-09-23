angular.module("BB.Directives").directive "bbWalletPayment", ($sce, $rootScope, $window, $location, SettingsService, AlertService, ErrorService) ->
  restrict: 'A'
  controller: 'Wallet'
  scope: true
  replace: true
  link: (scope, element, attrs) ->

    scope.options = scope.$eval(attrs.bbWalletPayment) or {}
    scope.member ||= $rootScope.member if $rootScope.member
    scope.member ||= scope.options.member if scope.options.member
    scope.amount = scope.options.amount if scope.options.amount
    scope.amount_increment = scope.options.amount_increment or 0


    getHost = (url) ->
      a = document.createElement('a')
      a.href = url
      a['protocol'] + '//' +a['host']


    sendLoadEvent = (element, origin, scope) ->
      referrer = $location.protocol() + "://" + $location.host()
      if $location.port()
        referrer += ":" + $location.port()
      
      custom_stylesheet = if scope.options.custom_stylesheet then scope.options.custom_stylesheet else null
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


    scope.add = (value) ->
      value = value or scope.amount_increment
      scope.amount += value


    scope.subtract = (value) ->
      value = value or scope.amount_increment
      scope.add(-value)


    scope.isSubtractValid = (value) ->
      return false if !scope.wallet
      value = value or scope.amount_increment
      new_amount = scope.amount - value 
      return new_amount >= scope.wallet.min_amount


    scope.$watch 'member', (member) ->
      if member?
        getWalletForMember()
      if scope.amount
        getWalletForMember()


    scope.$watch 'wallet', (wallet) ->
      if wallet
        scope.amount = wallet.min_amount if wallet.min_amount 
        if wallet.$has('new_payment')
          scope.wallet_payment_url = $sce.trustAsResourceUrl(scope.wallet.$href("new_payment"))
          element.find('iframe').bind 'load', (event) =>
            url = scope.wallet_payment_url if scope.wallet_payment_url
            origin = getHost(url)
            sendLoadEvent(element, origin, scope)
            scope.$apply ->
              scope.callSetLoaded()


    $window.addEventListener 'message', (event) =>
      if angular.isObject(event.data)
        data = event.data
      else if not event.data.match(/iFrameSizer/)
        data = JSON.parse event.data
      scope.$apply =>
        if data
          switch data.type
            when "submitting"
              scope.callNotLoaded()
            when "error"
              scope.callSetLoaded()
              scope.error(data.message)
              AlertService.warning(ErrorService.getAlert('TOPUP_FAILED'))
            when "wallet_payment_complete"
              scope.walletPaymentDone()
            when 'basket_wallet_payment_complete'
              # TODO how does it know to do this?????
              scope.callSetLoaded()
              scope.basketWalletPaymentDone()
    , false
