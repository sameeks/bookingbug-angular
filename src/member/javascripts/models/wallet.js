// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BB.Models").factory("Member.WalletModel", (WalletService, BBModel, BaseModel) =>

  class Member_Wallet extends BaseModel {
    constructor(data) {
      super(data);
    }

    static $getWalletForMember(member, params) {
      return WalletService.getWalletForMember(member, params);
    }

    static $getWalletLogs(wallet) {
      return WalletService.getWalletLogs(wallet);
    }

    static $getWalletPurchaseBandsForWallet(wallet) {
      return WalletService.getWalletPurchaseBandsForWallet(wallet);
    }

    static $updateWalletForMember(member, params) {
      return WalletService.updateWalletForMember(member, params);
    }

    static $createWalletForMember(member) {
      return WalletService.createWalletForMember(member);
    }
  }
);
