angular.module('BB.Controllers').controller('DealList', function($scope, $rootScope, $uibModal, $document, AlertService, FormDataStoreService, ValidatorService, LoadingService, BBModel, $translate) {

  FormDataStoreService.init('DealList', $scope, [ 'deals' ]);
  let loader = LoadingService.$loader($scope).notLoaded();

  console.warn('Deprecation warning: validator.validateForm() will be removed from bbDealList in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
  $scope.validator = ValidatorService;

  $rootScope.connection_started.then(() => init()
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

  var init = function() {
    loader.notLoaded();
    if (!$scope.deals) {
      let deal_promise = BBModel.Deal.$query($scope.bb.company);
      return deal_promise.then(function(deals) {
        $scope.deals = deals;
        return loader.setLoaded();
      });
    }
  };

  /***
  * @ngdoc method
  * @name selectDeal
  * @methodOf BB.Directives:bbDeals
  * @description
  * Select the deal and open modal
  *
  * @param {array} deal The deals array
  */
  $scope.selectDeal = function(deal) {
    let iitem = new (BBModel.BasketItem)(null, $scope.bb);
    iitem.setDefaults($scope.bb.item_defaults);
    iitem.setDeal(deal);
    if (!$scope.bb.company_settings.no_recipient) {
      let modalInstance = $uibModal.open({
        templateUrl: $scope.getPartial('_add_recipient'),
        scope: $scope,
        controller: ModalInstanceCtrl,
        resolve: {
          item() {
            return iitem;
          }
        }
      });

      return modalInstance.result.then(function(item) {
        loader.notLoaded();
        $scope.setBasketItem(item);
        return $scope.addItemToBasket().then(() => loader.setLoaded()
        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
      });
    } else {
      loader.notLoaded();
      $scope.setBasketItem(iitem);
      return $scope.addItemToBasket().then(() => loader.setLoaded()
      , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
    }
  };

  var ModalInstanceCtrl = function($scope, $uibModalInstance, item, ValidatorService) {
    $scope.item = item;
    $scope.recipient = false;

    /***
    * @ngdoc method
    * @name addToBasket
    * @methodOf BB.Directives:bbDeals
    * @description
    * Add to basket in according of form parameter
    *
    * @param {object} form The form where is added deal list to basket
    */
    $scope.addToBasket = function(form) {
      if (!ValidatorService.validateForm(form)) {
        return;
      }
      return $uibModalInstance.close($scope.item);
    };

    return $scope.cancel = () => $uibModalInstance.dismiss('cancel');
  };

  /***
  * @ngdoc method
  * @name purchaseDeals
  * @methodOf BB.Directives:bbDeals
  * @description
  * Purchase deals if basket items and basket items length is bigger than 0 else display a alert message
  */
  $scope.purchaseDeals = function() {
    if ($scope.bb.basket.items && ($scope.bb.basket.items.length > 0)) {
      return $scope.decideNextPage();
    } else {
      return AlertService.add('danger', {msg: $translate.instant('PUBLIC_BOOKING.DEAL_LIST.CERT_NOT_SELECTED_ALERT')});
    }
  };

  /***
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbDeals
  * @description
  * Set this page section as ready
  */
  return $scope.setReady = function() {
    if ($scope.bb.basket.items && ($scope.bb.basket.items.length > 0)) {
      return true;
    } else {
      return AlertService.add('danger', {msg: $translate.instant('PUBLIC_BOOKING.DEAL_LIST.CERT_NOT_SELECTED_ALERT')});
    }
  };
});
