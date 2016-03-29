'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbDeals
* @restrict AE
* @scope true
*
* @description
* Loads a list of deals for the currently in scope company.
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} deals Deals list
* @property {object} validator Validation service - see {@link BB.Services:Validator Validation Service}
* @property {object} alert Alert Service - see {@link BB.Services:Alert Alert Service}
####

angular.module('BB.Directives').directive 'bbDeals', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DealList'
  link: (scope, element, attrs) ->
    scope.options = scope.$eval(attrs.bbDeals)
    scope.directives = "public.DealList"

angular.module('BB.Controllers').controller 'DealList',
($scope, $rootScope, $q, $modal, AlertService, FormDataStoreService, ValidatorService, LoadingService, BBModel) ->

  $scope.controller = "public.controllers.DealList"
  FormDataStoreService.init 'TimeRangeList', $scope, [ 'deals' ]
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then ->
    init()
  , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  init = () ->
    loader.notLoaded()
    if !$scope.deals
      deal_promise = BBModel.Deal.$query($scope.bb.company)
      deal_promise.then (deals) ->
        $scope.deals = deals
        loader.setLoaded()

  ###**
  * @ngdoc method
  * @name selectDeal
  * @methodOf BB.Directives:bbDeals
  * @description
  * Select the deal and open modal.
  *
  * @param {array} deal Deals array
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
        loader.notLoaded()
        $scope.setBasketItem item
        $scope.addItemToBasket().then ->
          loader.setLoaded()
        , (err) ->
          loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    else
      loader.notLoaded()
      $scope.setBasketItem iitem
      $scope.addItemToBasket().then ->
        loader.setLoaded()
      , (err) ->
        loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ModalInstanceCtrl = ($scope, $modalInstance, item, ValidatorService) ->
    $scope.controller = 'ModalInstanceCtrl'
    $scope.item = item
    $scope.recipient = false

    ###**
    * @ngdoc method
    * @name addToBasket
    * @methodOf BB.Directives:bbDeals
    * @description
    * Add to basket according to form parameters.
    *
    * @param {object} form Form where deal list is added to basket
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
  * Purchase deals if basket items and basket items length is bigger than 0 else display a alert message.
  ###
  $scope.purchaseDeals = ->
    if $scope.bb.basket.items and $scope.bb.basket.items.length > 0
      $scope.decideNextPage()
    else
      AlertService.add('danger', msg: 'You need to select at least one Gift Certificate to continue')

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbDeals
  * @description
  * Sets page section as ready.
  ###
  $scope.setReady = ->
    if $scope.bb.basket.items and $scope.bb.basket.items.length > 0
      true
    else
      AlertService.add('danger', msg: 'You need to select at least one Gift Certificate to continue')
