angular.module("BBMember").controller "MemberPurchases", ($scope, $q, MemberPurchaseService, $log) ->

  $scope.loading = true

  $scope.getPurchases = () ->
    $scope.loading = true
    defer = $q.defer()
    MemberPurchaseService.query($scope.member, {}).then (purchases) ->
      console.log(purchases)
      $scope.purchases = purchases
      $scope.loading = false
      defer.resolve(purchases)
    , (err) ->
      $log.error err.data
      $scope.loading = false
      defer.promise