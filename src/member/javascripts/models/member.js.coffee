

###**
* @ngdoc service
* @name BB.Models:Member
*
* @description
* Representation of an Member Object
####


angular.module('BB.Models').factory "Member.MemberModel", ($q, BBModel,
    BaseModel, ClientModel) ->

  ###**
    * @ngdoc method
    * @name wallet
    * @methodOf BB.Models:Member
    * @description
    * Verify if member have wallet
    *
    * @returns {object} Returns the wallet
  ###
  class Member_Member extends ClientModel

    wallet: () ->
      if @$has("wallet")
        @$get("wallet").then (wallet) ->
          @wallet = wallet
          @wallet


