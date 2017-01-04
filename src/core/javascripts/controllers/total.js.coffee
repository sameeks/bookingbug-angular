'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbTotal
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of totals for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbTotal A hash of options
* @property {array} payment_status The payment status
* @property {array} total The total
####


angular.module('BB.Directives').directive 'bbTotal', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Total'

angular.module('BB.Controllers').controller 'Total', ($scope,  $rootScope, $q,
    $location, $window, QueryStringService, LoadingService) ->

  $scope.controller = "public.controllers.Total"
  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    loadTotal()

  , (err) ->
    loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  loadTotal = () ->
    $scope.bb.payment_status = null
    id = QueryStringService('purchase_id')
    # if purchase has been moved in modal then use that
    if $scope.purchase and !id
      $scope.total = $scope.bb.purchase
      loader.setLoaded()

    else if id and !$scope.bb.total
      BBModel.Purchase.Total.$query({url_root: $scope.bb.api_url, purchase_id: id}).then (total) ->
        $scope.total = total
        loader.setLoaded()
        
    else
      $scope.total = $scope.bb.total
      loader.setLoaded()

    emitSuccess($scope.total)
    # Reset ready for another booking
    $scope.reset()


  # emit checkout:success event if the amount paid matches the total price
  emitSuccess = (total) ->
    $scope.$emit("checkout:success", total) if total.paid is total.total_price

  ###**
  * @ngdoc method
  * @name print
  * @methodOf BB.Directives:bbTotal
  * @description
  * Open new window from partial url
  ###
  $scope.print = () =>
    $window.open($scope.bb.partial_url+'print_purchase.html?id='+$scope.total.long_id,'_blank',
                'width=700,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0')
    return true

  $rootScope.$on "booking:moved", (event, total) ->
    $scope.total = total
    emitSuccess(total)