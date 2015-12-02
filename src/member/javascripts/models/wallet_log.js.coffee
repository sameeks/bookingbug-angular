

###**
* @ngdoc service
* @name BB.Models:WalletLog
*
* @description
* Representation of an Wallet Log Object
####


angular.module("BB.Models").factory "Member.WalletLogModel", ($q, BBModel, BaseModel) ->
  
  class Member_WalletLog extends BaseModel
    constructor: (data) ->
      super(data)