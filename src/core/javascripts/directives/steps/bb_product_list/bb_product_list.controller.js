angular.module('BB.Controllers').controller('ProductList', function($scope, $rootScope, $q, $attrs, ItemService, FormDataStoreService, ValidatorService, LoadingService) {

  let loader = LoadingService.$loader($scope).notLoaded();

  $rootScope.connection_started.then(function() {
    if ($scope.bb.company) {
      return $scope.init($scope.bb.company);
    }
  }
  , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

  $scope.init = function(company) {
    if (!$scope.booking_item) { $scope.booking_item = $scope.bb.current_item; }

    return company.$get('products').then(products =>
      products.$get('products').then(function(products) {
        $scope.products = products;
        return loader.setLoaded();
      })
    );
  };

  /***
  * @ngdoc method
  * @name selectItem
  * @methodOf BB.Directives:bbProductList
  * @description
  * Select an item from the product list in according of item and route parameter
  *
  * @param {array} item The array items
  * @param {string=} route A specific route to load
  */
  return $scope.selectItem = function(item, route) {
    if ($scope.$parent.$has_page_control) {
      $scope.product = item;
      return false;
    } else {
      $scope.booking_item.setProduct(item);
      $scope.decideNextPage(route);
      return true;
    }
  };
});
