'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbDeals
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of deals for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} deals The deals list
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbDeals', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DealList'

angular.module('BB.Controllers').controller 'DealList', ($scope, $rootScope, DealService, $q, BBModel, AlertService, FormDataStoreService, ValidatorService, $modal, $translate) ->

  $scope.controller = "public.controllers.DealList"
  FormDataStoreService.init 'TimeRangeList', $scope, [ 'deals' ]

  $rootScope.connection_started.then ->
    init()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  init = () ->
    $scope.notLoaded $scope
    if !$scope.deals
      deal_promise = DealService.query($scope.bb.company)
      deal_promise.then (deals) ->
        $scope.deals = deals
        $scope.setLoaded $scope

  ###**
  * @ngdoc method
  * @name selectDeal
  * @methodOf BB.Directives:bbDeals
  * @description
  * Select the deal and open modal
  *
  * @param {array} deal The deals array
  ###
  $scope.selectDeal = (deal) ->
    iitem = new (BBModel.BasketItem)(null, $scope.bb)
    iitem.setDefaults $scope.bb.item_defaults
    iitem.setDeal deal
    if !$scope.bb.company_settings.no_recipient
      modalInstance = $modal.open
        templateUrl: $scope.getPartial('_add_recipient')
        scope: $scope
        controller: ModalInstanceCtrl
        resolve:
          item: ->
            iitem

      modalInstance.result.then (item) ->
        $scope.notLoaded $scope
        $scope.setBasketItem item
        $scope.addItemToBasket().then ->
          $scope.setLoaded $scope
        , (err) ->
          $scope.setLoadedAndShowError $scope, err, 'Sorry, something went wrong'
    else
      $scope.notLoaded $scope
      $scope.setBasketItem iitem
      $scope.addItemToBasket().then ->
        $scope.setLoaded $scope
      , (err) ->
        $scope.setLoadedAndShowError $scope, err, 'Sorry, something went wrong'

  ModalInstanceCtrl = ($scope, $modalInstance, item, ValidatorService) ->
    $scope.controller = 'ModalInstanceCtrl'
    $scope.item = item
    $scope.recipient = false

    ###**
    * @ngdoc method
    * @name addToBasket
    * @methodOf BB.Directives:bbDeals
    * @description
    * Add to basket in according of form parameter
    *
    * @param {object} form The form where is added deal list to basket
    ###
    $scope.addToBasket = (form) ->
      if !ValidatorService.validateForm(form)
        return
      $modalInstance.close($scope.item)

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'

  ###**
  * @ngdoc method
  * @name purchaseDeals
  * @methodOf BB.Directives:bbDeals
  * @description
  * Purchase deals if basket items and basket items length is bigger than 0 else display a alert message
  ###
  $scope.purchaseDeals = ->
    if $scope.bb.basket.items and $scope.bb.basket.items.length > 0
      $scope.decideNextPage()
    else
      AlertService.add('danger', msg: $translate.instant('SELECT_GIFT_CERTIFICATE'))

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbDeals
  * @description
  * Set this page section as ready
  ###
  $scope.setReady = ->
    if $scope.bb.basket.items and $scope.bb.basket.items.length > 0
      true
    else
      AlertService.add('danger', msg: $translate.instant('SELECT_GIFT_CERTIFICATE'))
