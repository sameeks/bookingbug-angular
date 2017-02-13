angular.module("BBMember").controller("Wallet", function($scope, $rootScope, $q,
  $log, AlertService, LoadingService, BBModel) {

  let updateClient;
  let loader = LoadingService.$loader($scope);

  $scope.getWalletForMember = function(member, params) {
    let defer = $q.defer();
    loader.notLoaded();
    BBModel.Member.Wallet.$getWalletForMember(member, params).then(function(wallet) {
      loader.setLoaded();
      $scope.wallet = wallet;
      updateClient(wallet);
      return defer.resolve(wallet);
    }
    , function(err) {
      loader.setLoaded();
      return defer.reject();
    });
    return defer.promise;
  };

  $scope.getWalletLogs = function() {
    let defer = $q.defer();
    loader.notLoaded();
    BBModel.Member.Wallet.$getWalletLogs($scope.wallet).then(function(logs) {
      logs = _.sortBy(logs, log => -moment(log.created_at).unix());
      loader.setLoaded();
      $scope.logs = logs;
      return defer.resolve(logs);
    }
    , function(err) {
      loader.setLoaded();
      $log.error(err.data);
      return defer.reject([]);
    });
    return defer.promise;
  };

  $scope.getWalletPurchaseBandsForWallet = function(wallet) {
    let defer = $q.defer();
    loader.notLoaded();
    BBModel.Member.Wallet.$getWalletPurchaseBandsForWallet(wallet).then(function(bands) {
      $scope.bands = bands;
      loader.setLoaded();
      return defer.resolve(bands);
    }
    , function(err) {
      loader.setLoaded();
      $log.error(err.data);
      return defer.resolve([]);
    });
    return defer.promise;
  };

  $scope.createWalletForMember = function(member) {
    loader.notLoaded();
    return BBModel.Member.Wallet.$createWalletForMember(member).then(function(wallet) {
      loader.setLoaded();
      return $scope.wallet = wallet;
    }
    , function(err) {
      loader.setLoaded();
      return $log.error(err.data);
    });
  };

  $scope.updateWallet = function(member, amount, band) {
    if (band == null) { band = null; }
    loader.notLoaded();
    if (member) {
      let params = {};
      if (amount > 0) { params.amount = amount; }
      if ($scope.wallet) { params.wallet_id = $scope.wallet.id; }
      if ($scope.total) { params.total_id = $scope.total.id; }
      if ($scope.deposit) { params.deposit = $scope.deposit; }
      if ($scope.basket) { params.basket_total_price = $scope.basket.total_price; }
      if (band) { params.band_id = band.id; }
      return BBModel.Member.Wallet.$updateWalletForMember(member, params).then(function(wallet) {
        loader.setLoaded();
        $scope.wallet = wallet;
        return $rootScope.$broadcast("wallet:updated", wallet, band);
      }
      , function(err) {
        loader.setLoaded();
        return $log.error(err.data);
      });
    }
  };

  $scope.activateWallet = function(member) {
    loader.notLoaded();
    if (member) {
      let params = {status: 1};
      if ($scope.wallet) { params.wallet_id = $scope.wallet.id; }
      return BBModel.Member.Wallet.$updateWalletForMember(member, params).then(function(wallet) {
        loader.setLoaded();
        return $scope.wallet = wallet;
      }
      , function(err) {
        loader.setLoaded();
        return $log.error(err.date);
      });
    }
  };

  $scope.deactivateWallet = function(member) {
    loader.notLoaded();
    if (member) {
      let params = {status: 0};
      if ($scope.wallet) { params.wallet_id = $scope.wallet.id; }
      return BBModel.Member.Wallet.$updateWalletForMember(member, params).then(function(wallet) {
        loader.setLoaded();
        return $scope.wallet = wallet;
      }
      , function(err) {
        loader.setLoaded();
        return $log.error(err.date);
      });
    }
  };

  $scope.purchaseBand = function(band) {
    $scope.selected_band = band;
    return $scope.updateWallet($scope.member, band.wallet_amount, band);
  };

  $scope.walletPaymentDone = () =>
    $scope.getWalletForMember($scope.member).then(function(wallet) {
      AlertService.raise('TOPUP_SUCCESS');
      $rootScope.$broadcast("wallet:topped_up", wallet);
      return $scope.wallet_topped_up = true;
    })
  ;

  // TODO don't route to next page automatically, first alert user
  // topup was successful and show new wallet balance + the 'next' button
  $scope.basketWalletPaymentDone = function() {
    $scope.callSetLoaded();
    return $scope.decideNextPage('checkout');
  };

  $scope.error = message => AlertService.warning('TOPUP_FAILED');

  $scope.add = function(value) {
    value = value || $scope.amount_increment;
    return $scope.amount += value;
  };

  $scope.subtract = function(value) {
    value = value || $scope.amount_increment;
    return $scope.add(-value);
  };

  $scope.isSubtractValid = function(value) {
    if (!$scope.wallet) { return false; }
    value = value || $scope.amount_increment;
    let new_amount = $scope.amount - value;
    return new_amount >= $scope.wallet.min_amount;
  };

  return updateClient = function(wallet) {
    if ($scope.member.self === $scope.client.self) {
      return $scope.client.wallet_amount = wallet.amount;
    }
  };
});
