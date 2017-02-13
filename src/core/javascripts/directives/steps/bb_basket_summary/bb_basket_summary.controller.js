angular.module('BB.Controllers').controller('BasketSummary', function($scope) {

  $scope.basket_items = $scope.bb.basket.items;

  /***
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbBasketSummary
  * @description
  * Marks the basket as reviewed and invokes the next step
  */
  return $scope.confirm = () => {
    $scope.bb.basket.reviewed = true;
    return $scope.decideNextPage();
  };
});
