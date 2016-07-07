###**
* @ngdoc directive
* @name BB.Directives:bbSummary
* @restrict AE
* @scope true
*
* @description
* Loads a summary of the booking
*
*
####


angular.module('BB.Directives').directive 'bbBasketSummary', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'BasketSummary'

angular.module('BB.Controllers').controller 'BasketSummary', ($scope) ->

  $scope.controller = "public.controllers.BasketSummary"

  $scope.basket_items = $scope.bb.basket.items


  console.log 'in directive', $scope.bb.basket.items


  ###**
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbSummary
  * @description
  * Submits the client and BasketItem to the API
  ###
  $scope.confirm = () =>

    # $scope.notLoaded $scope
    # $scope.setLoaded $scope
    # console.log 'BasketItems',$scope.items
    $scope.bb.basket.reviewed = true


    $scope.decideNextPage()

    # , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
