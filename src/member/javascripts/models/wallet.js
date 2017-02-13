angular.module("BB.Models").factory "Member.WalletModel", (WalletService, BBModel, BaseModel) ->

  class Member_Wallet extends BaseModel
    constructor: (data) ->
      super(data)

    @$getWalletForMember: (member, params) ->
      WalletService.getWalletForMember(member, params)

    @$getWalletLogs: (wallet) ->
      WalletService.getWalletLogs(wallet)

    @$getWalletPurchaseBandsForWallet: (wallet) ->
      WalletService.getWalletPurchaseBandsForWallet(wallet)

    @$updateWalletForMember: (member, params) ->
      WalletService.updateWalletForMember(member, params)

    @$createWalletForMember: (member) ->
      WalletService.createWalletForMember(member)
