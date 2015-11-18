'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbMiniBasket
* @restrict AE
* @scope true
*
* @description
* Loads a list of mini basket for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {boolean} setUsingBasket Set using basket  or not
####


angular.module('BB.Directives').directive 'bbMiniBasket', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'MiniBasket'



angular.module('BB.Controllers').controller 'MiniBasket', ($scope,  $rootScope, BasketService, $q) ->
  $scope.controller = "public.controllers.MiniBasket"
  $scope.setUsingBasket(true)
  $rootScope.connection_started.then () =>

  ###**
  * @ngdoc method
  * @name basketDescribe
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Basked describe in according of basket length 
  *
  * @param {string} nothing Nothing to describe
  * @param {string} single The single describe
  * @param {string} plural The plural describe
  ###
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


angular.module('BB.Controllers').controller 'BasketList', ($scope, $attrs, $rootScope, BasketService, $q, AlertService, FormDataStoreService, LoginService) ->
  $scope.controller = "public.controllers.BasketList"
  $scope.setUsingBasket(true)
  $scope.items = $scope.bb.basket.items
  $scope.show_wallet = $scope.bb.company_settings.hasOwnProperty('has_wallets') && $scope.bb.company_settings.has_wallets && $scope.client.valid() && LoginService.isLoggedIn() && LoginService.member().id == $scope.client.id

  # bb.basket.options - added 10-11-2015 @16:19
  # For ex. bb-basket-list="{requires_deal: true}" 
  $scope.bb.basket.setSettings($scope.$eval $attrs.bbBasketList or {})

  $scope.$watch 'basket', (newVal, oldVal) =>
    $scope.items = _.filter $scope.bb.basket.items, (item) -> !item.is_coupon


  ###**
  * @ngdoc method
  * @name addAnother
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Add another basket item in acording of route parameter
  *
  * @param {string} route A route of the added another item
  ###
  $scope.addAnother = (route) =>
    $scope.clearBasketItem()
    $scope.bb.emptyStackedItems()
    $scope.bb.current_item.setCompany($scope.bb.company)
    $scope.restart()

  ###**
  * @ngdoc method
  * @name checkout
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Reset the basket to the last item whereas the curren_item is not complete and should not be in the basket and that way, we can proceed to checkout instead of hard-coding it on the html page.
  *
  * @param {string} route A route of the added another item
  ###
  $scope.checkout = (route) =>
    # Reset the basket to the last item whereas the curren_item is not complete and should not be in the basket and that way, we can proceed to checkout instead of hard-coding it on the html page.
    $scope.setReadyToCheckout(true)
    if $scope.bb.basket.items.length > 0
      $scope.decideNextPage(route)
    else
      AlertService.clear()
      AlertService.raise('EMPTY_BASKET_FOR_CHECKOUT')
      return false

  ###**
  * @ngdoc method
  * @name applyCoupon
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Apply the coupon of basket item in according of coupon parameter
  *
  * @param {string} coupon The applied coupon
  ###
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

  ###**
  * @ngdoc method
  * @name applyDeal
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Apply the coupon of basket item in according of deal code parameter
  *
  * @param {string} deal code The deal code
  ###
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

  ###**
  * @ngdoc method
  * @name removeDeal
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Remove the deal in according of deal code parameter
  *
  * @param {string} deal code The deal code
  ###
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


  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbMiniBasket
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = ->    
    if $scope.bb.basket.settings and $scope.bb.basket.settings.requires_deal && !$scope.bb.basket.hasDeal()     
      AlertService.raise('GIFT_CERTIFICATE_REQUIRED')
      return false   
    if $scope.bb.basket.items.length > 0
      $scope.setReadyToCheckout(true)
      return true
    else
      AlertService.raise('EMPTY_BASKET_FOR_CHECKOUT')
      return false
      