###**
* @ngdoc directive
* @name BB.Directives:bbBasketSummary
* @restrict AE
* @scope true
*
* @description
* Loads a summary of the bookings and allows the user to  review and
* confirm the previously entered information
####


angular.module('BB.Directives').directive 'bbBasketSummary', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'BasketSummary'

angular.module('BB.Controllers').controller 'BasketSummary', ($scope) ->

  $scope.controller = "public.controllers.BasketSummary"

  $scope.basket_items = $scope.bb.basket.items

  $scope.$emit 'ParentModal:changeTitle', { title: 'Summary'}
  $scope.$on '$destroy', () ->
     $scope.$emit 'ParentModal:changeTitle', { title: ''}

  ###**
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbBasketSummary
  * @description
  * Marks the basket as reviewed and invokes the next step
  ###
  $scope.confirm = () =>
    $scope.bb.basket.reviewed = true
    $scope.decideNextPage()
