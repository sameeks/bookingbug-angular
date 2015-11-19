angular.module("BB.Models").factory "Member.PurchaseModel", (BBModel, BaseModel) ->

  class Member_Purchase extends BaseModel
    constructor: (data) ->
      super(data)

      @created_at = moment.parseZone(@created_at)
      @created_at.tz(@time_zone) if @time_zone

    getItems: ->
      @_data.$get('purchase_items').then (items) ->
        @items = for item in items
          new BBModel.Member.PurchaseItem(item)
        return @items