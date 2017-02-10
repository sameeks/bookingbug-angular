'use strict'

angular.module('BB.Controllers').controller 'Total', ($scope, $rootScope, $q,
    $location, $window, QueryStringService, LoadingService, BBModel) ->

  loader = LoadingService.$loader($scope).notLoaded()

  $rootScope.connection_started.then =>
    loadTotal()

  , (err) ->
    loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


  ###**
  * @ngdoc method
  * @name loadTotal
  * @methodOf BB.Directives:bbTotal
  * @description
  * Load purchase from either url or total if it's already in scope
  ###

  loadTotal = () ->
    $scope.bb.payment_status = null
    id = QueryStringService('purchase_id')

    # if purchase has been moved in modal then use that
    if $scope.bb.purchase and !id
      $scope.total = $scope.bb.purchase

    # else get from ID found from URL
    else if id and !$scope.bb.total
      BBModel.Purchase.Total.$query({url_root: $scope.bb.api_url, purchase_id: id}).then (total) ->
        $scope.total = total
        
    # not sure if this is needed
    else if $scope.bb.total
      $scope.total = $scope.bb.total 

    else 
      console.log 'no purchase total found'
      return
      
    loader.setLoaded()
    emitSuccess($scope.total)
    # Reset ready for another booking
    $scope.reset()


  ###**
  * @ngdoc method
  * @name emitSuccess
  * @methodOf BB.Directives:bbTotal
  * @description
  * Emit checkout:success if total has been paid
  * @param {object} total The purchase total 
  ###

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

