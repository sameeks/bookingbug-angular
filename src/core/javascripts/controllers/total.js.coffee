'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbTotal
* @restrict AE
* @scope true
*
* @description
* Loads a list of totals for the currently in scope company.
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbTotal Hash options
* @property {array} payment_status Payment status
* @property {array} total The total
* @example
*  <example module="BB">
*    <file name="index.html">
*      <div bb-api-url='https://dev01.bookingbug.com'>
*        <div bb-widget='{company_id:37167}'>
*          <div bb-total>
*
*          </div>
*        </div>
*      </div>
*    </file>
*  </example>
####

angular.module('BB.Directives').directive 'bbTotal', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Total'


angular.module('BB.Controllers').controller 'Total', ($scope,  $rootScope, $q, $location, $window, PurchaseService, QueryStringService, LoadingService) ->

  $scope.controller = "public.controllers.Total"
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    $scope.bb.payment_status = null

    id = QueryStringService('purchase_id')

    if id and !$scope.bb.total
      PurchaseService.query({url_root: $scope.bb.api_url, purchase_id: id}).then (total) ->
        $scope.total = total
        $scope.setLoaded $scope

        # emit checkout:success event if the amount paid matches the total price
        $scope.$emit("checkout:success", total) if total.paid == total.total_price
    else
      $scope.total = $scope.bb.total
      $scope.setLoaded $scope

      # emit checkout:success event if the amount paid matches the total price
      $scope.$emit("checkout:success", $scope.total) if $scope.total.paid == $scope.total.total_price

    # Reset ready for another booking
    $scope.reset()

  , (err) ->
    loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name print
  * @methodOf BB.Directives:bbTotal
  * @description
  * Open new window from partial url.
  ###
  $scope.print = () =>
    $window.open($scope.bb.partial_url+'print_purchase.html?id='+$scope.total.long_id,'_blank',
                'width=700,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0')
    return true
