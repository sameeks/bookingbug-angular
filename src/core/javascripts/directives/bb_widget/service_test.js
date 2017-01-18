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

  addItemToBasket = function() {
    guardScope();
    var add_defer;
    add_defer = $q.defer();
    if (!$scope.bb.current_item.submitted && !$scope.bb.moving_booking) {
      moveToBasket();
      $scope.bb.current_item.submitted = updateBasket();
      $scope.bb.current_item.submitted.then(function(basket) {
        return add_defer.resolve(basket);
      }, function(err) {
        if (err.status === 409) {
          $scope.bb.current_item.person = null;
          $scope.bb.current_item.resource = null;
          $scope.bb.current_item.setTime(null);
          if ($scope.bb.current_item.service) {
            $scope.bb.current_item.setService($scope.bb.current_item.service);
          }
        }
        $scope.bb.current_item.submitted = null;
        return add_defer.reject(err);
      });
    } else if ($scope.bb.current_item.submitted) {
      return $scope.bb.current_item.submitted;
    } else {
      add_defer.resolve();
    }
    return add_defer.promise;
  };

  updateBasket = function() {
    guardScope();
    var add_defer, current_item_ref, params;
    current_item_ref = $scope.bb.current_item.ref;
    add_defer = $q.defer();
    params = {
      member_id: $scope.client.id,
      member: $scope.client,
      items: $scope.bb.basket.items,
      bb: $scope.bb
    };

    }

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

  return {
    updateBasket: updateBasket,
    addItemToBasket: addItemToBasket,
    getScope: getScope,
    setScope: setScope,
    first: function(prms) {alert(prms);},
    setBasket : setBasket,
    deleteBasketItems : deleteBasketItems
  };
});
