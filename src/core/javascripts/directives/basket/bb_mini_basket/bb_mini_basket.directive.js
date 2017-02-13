// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbMiniBasket
* @restrict AE
* @scope true
*
* @description
* Loads a list of mini basket for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {boolean} setUsingBasket Set using basket  or not
*///


angular.module('BB.Directives').directive('bbMiniBasket', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller($scope, $rootScope, BasketService, $q) {
      $scope.setUsingBasket(true);
      $rootScope.connection_started.then(() => {});

      /***
      * @ngdoc method
      * @name basketDescribe
      * @methodOf BB.Directives:bbMiniBasket
      * @description
      * Basked describe in according of basket length
      *
      * @param {string} nothing Nothing to describe
      * @param {string} single The single describe
      * @param {string} plural The plural describe
      */
      return $scope.basketDescribe = (nothing, single, plural) => {
        if (!$scope.bb.basket || ($scope.bb.basket.length() === 0)) {
          return nothing;
        } else if ($scope.bb.basket.length() === 1) {
          return single;
        } else {
          return plural.replace("$0", $scope.bb.basket.length());
        }
      };
    }
  })
);
