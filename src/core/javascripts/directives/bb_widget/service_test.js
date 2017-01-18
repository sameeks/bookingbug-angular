'use strict';
angular.module('BB.Services').factory("basketRelated", function($q, $window, halClient, BBModel) {

  $scope = null;
  setScope = function ($s) {
    $scope = $s;
  };
  getScope = function () {
    return $scope;
  };
  guardScope = function () {
    if($scope === null){
      throw new Erro('please provide scope'); //tewt
    }
  };
  setBasket = function(basket) {
    guardScope();
    debugger;
    $scope.bb.basket = basket;
    $scope.basket = basket;
    $scope.bb.basket.company_id = $scope.bb.company_id;
    if ($scope.bb.stacked_items) {
      return $scope.bb.setStackedItems(basket.timeItems());
    }
  };

  deleteBasketItems = function(items) {
      guardScope();
      debugger;
      var item, j, len, results;
      results = [];
      for (j = 0, len = items.length; j < len; j++) {
        item = items[j];
        results.push(BBModel.Basket.$deleteItem(item, $scope.bb.company, {
          bb: $scope.bb
        }).then(function(basket) {
          return setBasket(basket);
        }));
      }
      return results;
    };

  setBasketItem = function(item) {
      return $scope.bb.current_item = item;
    };


  return {
    getScope: getScope,
    setScope: setScope,
    first: function(prms) {alert(prms);},
    setBasket : setBasket,
    deleteBasketItems : deleteBasketItems,
    setBasketItem: setBasketItem
  };
});
