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
    $scope.bb.basket = basket;
    $scope.basket = basket;
    $scope.bb.basket.company_id = $scope.bb.company_id;
    if ($scope.bb.stacked_items) {
      return $scope.bb.setStackedItems(basket.timeItems());
    }
  };

  deleteBasketItems = function(items) {
      guardScope();
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
      guardScope();
      return $scope.bb.current_item = item;
    };


  clearBasketItem = function() {
      guardScope();
      var def;
      def = $q.defer();
      $scope.bb.current_item = new BBModel.BasketItem(null, $scope.bb);
      if ($scope.bb.default_setup_promises) {
        $q.all($scope.bb.default_setup_promises)["finally"](function() {
          $scope.bb.current_item.setDefaults($scope.bb.item_defaults);
          return $q.all($scope.bb.current_item.promises)["finally"](function() {
            return def.resolve();
          });
        });
      } else {
        $scope.bb.current_item.setDefaults({});
        def.resolve();
      }
      return def.promise;
    };

    setBasket = function(basket) {
      guardScope();
      $scope.bb.basket = basket;
      $scope.basket = basket;
      $scope.bb.basket.company_id = $scope.bb.company_id;
      if ($scope.bb.stacked_items) {
        return $scope.bb.setStackedItems(basket.timeItems());
      }
    };

    updateBasket = function() {
      var add_defer, current_item_ref, params;
      current_item_ref = $scope.bb.current_item.ref;
      add_defer = $q.defer();
      params = {
        member_id: $scope.client.id,
        member: $scope.client,
        items: $scope.bb.basket.items,
        bb: $scope.bb
      };
      BBModel.Basket.$updateBasket($scope.bb.company, params).then(function(basket) {
        var current_item, item, j, len, ref;
        ref = basket.items;
        for (j = 0, len = ref.length; j < len; j++) {
          item = ref[j];
          item.storeDefaults($scope.bb.item_defaults);
        }
        halClient.clearCache("time_data");
        halClient.clearCache("events");
        basket.setSettings($scope.bb.basket.settings);
        setBasket(basket);
        current_item = _.find(basket.items, function(item) {
          return item.ref === current_item_ref;
        });
        if (!current_item) {
          current_item = _.last(basket.items);
        }
        $scope.bb.current_item = current_item;
        if (!$scope.bb.current_item) {
          return clearBasketItem().then(function() {
            return add_defer.resolve(basket);
          });
        } else {
          return add_defer.resolve(basket);
        }
      }, function(err) {
        var error_modal;
        add_defer.reject(err);
        if (err.status === 409) {
          halClient.clearCache("time_data");
          halClient.clearCache("events");
          $scope.bb.current_item.person = null;
          error_modal = $uibModal.open({
            templateUrl: getPartial('_error_modal'),
            controller: function($scope, $uibModalInstance) {
              $scope.message = ErrorService.getError('ITEM_NO_LONGER_AVAILABLE').msg;
              return $scope.ok = function() {
                return $uibModalInstance.close();
              };
            }
          });
          return error_modal.result["finally"](function() {
            if ($scope.bb.on_conflict) {
              return $scope.$eval($scope.bb.on_conflict);
            } else {
              if ($scope.bb.nextSteps) {
                if (setPageRoute($rootScope.Route.Date)) {

                } else if (setPageRoute($rootScope.Route.Event)) {

                } else {
                  return loadPreviousStep();
                }
              } else {
                return decideNextPage();
              }
            }
          });
        }
      });
      return add_defer.promise;
    };

  return {
    getScope: getScope,
    setScope: setScope,
    first: function(prms) {alert(prms);},
    setBasket : setBasket,
    deleteBasketItems : deleteBasketItems,
    setBasketItem: setBasketItem,
    clearBasketItem: clearBasketItem,
    setBasket: setBasket,
    updateBasket: updateBasket
  };
});
