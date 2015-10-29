'use strict';

angular.module('BB.Directives').directive 'bbMiniBasket', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'MiniBasket'



angular.module('BB.Controllers').controller 'MiniBasket', ($scope,  $rootScope, BasketService, $q) ->
  $scope.controller = "public.controllers.MiniBasket"
  $scope.setUsingBasket(true)
  $rootScope.connection_started.then () =>

  $scope.basketDescribe = (nothing, single, plural) =>
    if !$scope.bb.basket || $scope.bb.basket.length() == 0
      nothing
    else if $scope.bb.basket.length() == 1
      single
    else
      plural.replace("$0", $scope.bb.basket.length())



angular.module('BB.Directives').directive 'bbBasketList', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'BasketList'



angular.module('BB.Controllers').controller 'BasketList', ($scope, $element, $attrs, $rootScope, BasketService, $q, AlertService, ErrorService, FormDataStoreService, LoginService) ->

  $scope.controller = "public.controllers.BasketList"
  $scope.setUsingBasket(true)
  $scope.show_wallet = $scope.bb.company_settings.hasOwnProperty('has_wallets') and $scope.bb.company_settings.has_wallets and $scope.client.valid() and LoginService.isLoggedIn() and LoginService.member().id == $scope.client.id and $scope.client.has_active_wallet

  $scope.basket_options = $scope.$eval($attrs.bbBasketList) or {}

  
  $rootScope.connection_started.then ->

    
    $scope.bb.basket.setClient($scope.client) if $scope.client


    if $scope.client.$has('pre_paid_bookings')

      $scope.notLoaded $scope
      promises = []

      for basket_item in $scope.bb.basket.timeItems()
        params = {event_id: basket_item.getEventId()}
        promises.push($scope.client.getPrePaidBookingsPromise(params))

      $q.all(promises).then (result) ->

        for basket_item, index in $scope.bb.basket.timeItems()
          prepaid_bookings = result[index]

          if $scope.basket_options.auto_use_prepaid_bookings and prepaid_bookings.length > 0
            basket_item.setPrepaidBooking(prepaid_bookings[0]) 

        $scope.setLoaded $scope
        
      , (err) ->
        $scope.setLoaded $scope


  $scope.addAnother = (route) =>
    $scope.clearBasketItem()
    $scope.bb.emptyStackedItems()
    $scope.bb.current_item.setCompany($scope.bb.company)
    $scope.restart()


  $scope.checkout = (route) =>

    if $scope.bb.basket.items.length > 0
      $scope.setReadyToCheckout(true)
      if $scope.$parent.$has_page_control
        return true
      else
        $scope.decideNextPage(route)
    else
      AlertService.clear()
      AlertService.add 'info', ErrorService.getError('EMPTY_BASKET_FOR_CHECKOUT')
      return false


  $scope.setReady = () ->
    return $scope.checkout()


  $scope.applyCoupon = (coupon) =>
    AlertService.clear()
    $scope.notLoaded $scope
    params = {bb: $scope.bb, coupon: coupon }
    BasketService.applyCoupon($scope.bb.company, params).then (basket) ->
      for item in basket.items
        item.storeDefaults($scope.bb.item_defaults)
        item.reserve_without_questions = $scope.bb.reserve_without_questions
      basket.setSettings($scope.bb.basket.settings)
      $scope.setBasket(basket)
      $scope.setLoaded $scope
    , (err) ->
      if err and err.data and err.data.error
        AlertService.clear()
        AlertService.add("danger", { msg: err.data.error })
      $scope.setLoaded $scope


  $scope.applyDeal = (deal_code) =>
    AlertService.clear()
    if $scope.client
      params = {bb: $scope.bb, deal_code: deal_code, member_id: $scope.client.id}
    else
      params = {bb: $scope.bb, deal_code: deal_code, member_id: null}
    BasketService.applyDeal($scope.bb.company, params).then (basket) ->

      for item in basket.items
        item.storeDefaults($scope.bb.item_defaults)
        item.reserve_without_questions = $scope.bb.reserve_without_questions
      basket.setSettings($scope.bb.basket.settings)
      $scope.setBasket(basket)
      $scope.items = $scope.bb.basket.items
      $scope.deal_code = null
    , (err) ->
      if err and err.data and err.data.error
        AlertService.clear()
        AlertService.add("danger", { msg: err.data.error })


  $scope.removeDeal = (deal_code) =>
    params = {bb: $scope.bb, deal_code_id: deal_code.id }
    BasketService.removeDeal($scope.bb.company, params).then (basket) ->

      for item in basket.items
        item.storeDefaults($scope.bb.item_defaults)
        item.reserve_without_questions = $scope.bb.reserve_without_questions
      basket.setSettings($scope.bb.basket.settings)
      $scope.setBasket(basket)
      $scope.items = $scope.bb.basket.items
    , (err) ->
      if err and err.data and err.data.error
        AlertService.clear()
        AlertService.add("danger", { msg: err.data.error })
  

  $scope.topUpWallet = () ->
    $scope.decideNextPage("basket_wallet")



      