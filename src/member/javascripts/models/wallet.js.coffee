
###**
* @ngdoc service
* @name BB.Models:MemberWallet
*
* @description
* Representation of an Wallet Object
####

angular.module("BB.Models").factory "Member.WalletModel",
(WalletService, BBModel, BaseModel) ->

  class Member_Wallet extends BaseModel
    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name $getWalletForMember
    * @methodOf BB.Models:MemberWallet
    * @description
    * Static function that gets the wallet for a specific member.
    *
    * @param {object} member member parameter
    * @param {object} params params parameter
    *
    * @returns {Promise} A promise that on success will return the member wallet
    ###
    @$getWalletForMember: (member, params) ->
      WalletService.getWalletForMember(member, params)

    ###**
    * @ngdoc method
    * @name $getWalletLogs
    * @methodOf BB.Models:MemberWallet
    * @description
    * Static function that gets the wallet for a specific member.
    *
    * @param {object} wallet wallet parameter
    *
    * @returns {Promise} A promise that on success will return an array of wallet logs
    ###
    @$getWalletLogs: (wallet) ->
      WalletService.getWalletLogs(wallet)

    ###**
    * @ngdoc method
    * @name $getWalletPurchaseBandsForWallet
    * @methodOf BB.Models:MemberWallet
    * @description
    * Static function that gets the wallet purchase bands.
    *
    * @param {object} wallet wallet parameter
    *
    * @returns {Promise} A promise that on success will return an array of wallet purchase bands
    ###
    @$getWalletPurchaseBandsForWallet: (wallet) ->
      WalletService.getWalletPurchaseBandsForWallet(wallet)

    ###**
    * @ngdoc method
    * @name $updateWalletForMember
    * @methodOf BB.Models:MemberWallet
    * @description
    * Static function that updates the wallet for a member.
    *
    * @param {object} member member parameter
    * @param {object} params params parameter
    *
    * @returns {Promise} A promise that on success will return an wallet object
    ###
    @$updateWalletForMember: (member, params) ->
      WalletService.updateWalletForMember(member, params)

    ###**
    * @ngdoc method
    * @name $createWalletForMember
    * @methodOf BB.Models:MemberWallet
    * @description
    * Static function that creates the wallet for a member.
    *
    * @param {object} member member parameter
    *
    * @returns {Promise} A promise that on success will return the newly created wallet object
    ###
    @$createWalletForMember: (member) ->
      WalletService.createWalletForMember(member)
