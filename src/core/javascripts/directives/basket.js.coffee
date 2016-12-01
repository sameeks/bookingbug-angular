'use strict'

#
# Basket Directive
# Example usage;
# <div bb-basket></div>
# <div bb-basket mini></div>
#
angular.module('BB.Directives').directive 'bbBasket', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : true
  templateUrl : (element, attrs) ->
    if _.has attrs, 'mini'
    then PathSvc.directivePartial "_basket_mini"
    else PathSvc.directivePartial "basket"
  controllerAs : 'BasketCtrl'

  controller : ($scope, $uibModal, $document, BasketService) ->
    $scope.setUsingBasket true

    this.empty = () ->
      $scope.$eval('emptyBasket()')

    this.view = ->
      $scope.$eval('viewBasket()')

    $scope.showBasketDetails = () ->
      if ($scope.bb.current_page == "basket") || ($scope.bb.current_page == "checkout")
        return false
      else
        modalInstance = $uibModal.open
          templateUrl: $scope.getPartial "_basket_details"
          scope: $scope
          controller: BasketInstanceCtrl
          resolve:
            basket: ->
              $scope.bb.basket

    BasketInstanceCtrl = ($scope,  $rootScope, $uibModalInstance, basket) ->
      $scope.basket = basket

      $scope.cancel = () ->
        $uibModalInstance.dismiss "cancel"

    $scope.$watch ->
      $scope.basketItemCount = len = if $scope.bb.basket then $scope.bb.basket.length() else 0
      $scope.basketStatus = $translate.instant("PUBLIC_BOOKING.BASKET_DETAILS.BASKET_STATUS", {N: len}, "messageformat")
      return
    return

  link : (scope, element, attrs) ->
    # stop the default action of links inside directive. you can pass the $event
    # object in from the view to the function bound to ng-click but this keeps
    # the markup tidier
    element.bind 'click', (e) ->
      e.preventDefault()


angular.module('BB.Directives').directive 'bbMinSpend', () ->
  restrict: 'A'
  scope: true
  controller: ($scope, $element, $attrs, AlertService, $translate) ->

    options = $scope.$eval $attrs.bbMinSpend or {}
    $scope.min_spend = options.min_spend or 0
    #$scope.items = options.items or {}

    $scope.setReady = () ->
      return checkMinSpend()

    checkMinSpend = () ->
      price = 0
      for item in $scope.bb.stacked_items
        price += (item.service.price)

      if price >= $scope.min_spend
        AlertService.clear()
        return true
      else
        AlertService.clear()
        AlertService.add("warning", { msg: $translate.instant('SPEND_AT_LEAST', min_spend: $scope.min_spend)})
        return false

