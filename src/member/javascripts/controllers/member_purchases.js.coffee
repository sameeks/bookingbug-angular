angular.module("BBMember").controller "MemberPurchases", ($scope, $q, $log, LoadingService, BBModel) ->

  $scope.getPurchases = () ->
    loader = LoadingService.$loader($scope).notLoaded()
    defer = $q.defer()
    BBModel.Member.Purchase.$query($scope.member, {}).then (purchases) ->
      $scope.purchases = purchases
      loader.setLoaded()
      defer.resolve(purchases)
    , (err) ->
      $log.error err.data
      loader.setLoaded()
      defer.reject([])

    return defer.promise
