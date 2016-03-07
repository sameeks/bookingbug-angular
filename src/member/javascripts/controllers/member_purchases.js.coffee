angular.module("BBMember").controller "MemberPurchases", ($scope, $q, MemberPurchaseService, $log) ->

  $scope.getPurchases = () ->
    $scope.notLoaded $scope
    defer = $q.defer()
    MemberPurchaseService.query($scope.member, {}).then (purchases) ->
      $scope.purchases = purchases
      $scope.setLoaded $scope
      defer.resolve(purchases)
    , (err) ->
      $log.error err.data
      $scope.setLoaded $scope
      defer.reject([])
    
    return defer.promise
    
