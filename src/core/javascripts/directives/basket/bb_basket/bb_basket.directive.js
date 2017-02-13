//
// Basket Directive
// Example usage;
// <div bb-basket></div>
// <div bb-basket mini></div>
//
angular.module('BB.Directives').directive('bbBasket', PathSvc =>
  ({
    restrict: 'A',
    replace: true,
    scope : true,
    templateUrl(element, attrs) {
      if (_.has(attrs, 'mini')) {
      return PathSvc.directivePartial("_basket_mini");
      } else { return PathSvc.directivePartial("basket"); }
    },
    controllerAs : 'BasketCtrl',

    controller($scope, $uibModal, $translate, $document, BasketService) {
      $scope.setUsingBasket(true);

      this.empty = () => $scope.$eval('emptyBasket()');

      this.view = () => $scope.$eval('viewBasket()');

      $scope.showBasketDetails = function() {
        if (($scope.bb.current_page === "basket") || ($scope.bb.current_page === "checkout")) {
          return false;
        } else {
          let modalInstance;
          return modalInstance = $uibModal.open({
            templateUrl: $scope.getPartial("_basket_details"),
            scope: $scope,
            controller: BasketInstanceCtrl,
            resolve: {
              basket() {
                return $scope.bb.basket;
              }
            }
          });
        }
      };

      var BasketInstanceCtrl = function($scope,  $rootScope, $uibModalInstance, basket) {
        $scope.basket = basket;

        return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
      };

      $scope.$watch(function() {
        let len;
        $scope.basketItemCount = len = $scope.bb.basket ? $scope.bb.basket.length() : 0;
        $scope.basketStatus = $translate.instant("PUBLIC_BOOKING.BASKET_DETAILS.BASKET_STATUS", {N: len}, "messageformat");
      });
    },

    link(scope, element, attrs) {
      // stop the default action of links inside directive. you can pass the $event
      // object in from the view to the function bound to ng-click but this keeps
      // the markup tidier
      return element.bind('click', e => e.preventDefault());
    }
  })
);
