angular.module("BB.Models").factory "Member.PurchaseItemModel", (BBModel, BaseModel) ->

  class Member_PurchaseItem extends BaseModel
    constructor: (data) ->
      super(data)
