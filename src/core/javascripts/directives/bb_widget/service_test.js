'use strict';
angular.module('BB.Services').factory("basketRelated", function($q, $window, halClient, BBModel) {

  this.$scope = null;

  setScope = function ($scope) {
    this.$scope = $scope;
  }

  guardScope = function () {
    if($scope === null){
      throw new Erro('please provide scope');
    }
  }



  setBasket = function(basket) {
    guardScope();
    this.$scope.bb.basket = basket;
    this.$scope.basket = basket;
    this.$scope.bb.basket.company_id = this.$scope.bb.company_id;
    if (this.$scope.bb.stacked_items) {
      return this.$scope.bb.setStackedItems(basket.timeItems());
    }
  }

  return {

    setScope: setScope,
    first: function(prms) {alert(prms);},
    setBasket : setBasket,
    deleteBasketItems : function(items) {
      guardScope();
      var item, j, len, results;
      results = [];
      for (j = 0, len = items.length; j < len; j++) {
        item = items[j];
        results.push(BBModel.Basket.$deleteItem(item, this.$scope.bb.company, {
          bb: this.$scope.bb
        }).then(function(basket) {
          return setBasket(basket,this.$scope);
        }));
      }
      return results;
    },



    emptyBasket : function() {
      guardScope();
      var defer;
      defer = $q.defer();
      if (!$scope.bb.basket.items || ($scope.bb.basket.items && $scope.bb.basket.items.length === 0)) {
        defer.resolve();
      } else {
        BBModel.Basket.$empty($scope.bb).then(function(basket) {
          if ($scope.bb.current_item.id) {
            delete $scope.bb.current_item.id;
          }
          setBasket(basket);
          return defer.resolve();
        }, function(err) {
          return defer.reject();
        });
      }
      return defer.promise;
    }


  };
});
