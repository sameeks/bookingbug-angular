angular.module("BBMember").controller("MemberPurchases", ($scope, $q, $log, LoadingService, BBModel) =>

  $scope.getPurchases = function() {
    let loader = LoadingService.$loader($scope).notLoaded();
    let defer = $q.defer();
    BBModel.Member.Purchase.$query($scope.member, {}).then(function(purchases) {
      $scope.purchases = purchases;
      loader.setLoaded();
      return defer.resolve(purchases);
    }
    , function(err) {
      $log.error(err.data);
      loader.setLoaded();
      return defer.reject([]);
    });

    return defer.promise;
  }
);
