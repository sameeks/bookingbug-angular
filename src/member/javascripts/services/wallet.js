// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BBMember.Services").factory("WalletService", ($q, BBModel) =>

  ({
    getWalletForMember(member, params) {
      if (!params) { params = {}; }
      params.no_cache = true;
      let deferred = $q.defer();
      if (!member.$has("wallet")) {
        deferred.reject("Wallets are not turned on.");
      } else {
        member.$get("wallet", params).then(function(wallet) {
          wallet = new BBModel.Member.Wallet(wallet);
          return deferred.resolve(wallet);
        }
        , err => deferred.reject(err));
      }
      return deferred.promise;
    },

    getWalletLogs(wallet) {
      let params = {no_cache: true};
      let deferred = $q.defer();
      if (!wallet.$has('logs')) {
        deferred.reject("No wallet transactions found");
      } else {
        wallet.$get('logs', params).then(resource =>
          resource.$get('logs').then(function(logs) {
            logs = (Array.from(logs).map((log) => new BBModel.Member.WalletLog(log)));
            return deferred.resolve(logs);
          })
        
        , err => {
          return deferred.reject(err);
        }
        );
      }

      return deferred.promise;
    },

    getWalletPurchaseBandsForWallet(wallet) {
      let deferred = $q.defer();
      if (!wallet.$has('purchase_bands')) {
        deferred.reject("No Purchase Bands");
      } else {
        wallet.$get("purchase_bands", {}).then(resource =>
          resource.$get("purchase_bands").then(function(bands) {
            bands = (Array.from(bands).map((band) => new BBModel.Member.WalletPurchaseBand(band)));
            return deferred.resolve(bands);
          })
        
        , err => deferred.reject(err));
      }
      return deferred.promise;
    },

    updateWalletForMember(member, params) {
      let deferred = $q.defer();
      if (!member.$has("wallet")) {
        deferred.reject("Wallets are not turned on.");
      } else {
        member.$put("wallet", {}, params).then(function(wallet) {
          wallet = new BBModel.Member.Wallet(wallet);
          return deferred.resolve(wallet);
        }
        , err => deferred.reject(err));
      }
      return deferred.promise;
    },

    createWalletForMember(member) {
      let deferred = $q.defer();
      let params = {};
      if (!member.$has("wallet")) {
        deferred.reject("Wallets are not turned on.");
      } else {
        member.$post("wallet", {}, params).then(function(wallet) {
          wallet = new BBModel.Member.Wallet(wallet);
          return deferred.resolve(wallet);
        }
        , err => deferred.reject(err));
      }
      return deferred.promise;
    }
  })
);
