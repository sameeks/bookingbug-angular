angular.module("BB.Models").factory "Member.PurchaseModel", (BBModel, BaseModel, $q) ->

  class Member_Purchase extends BaseModel
    
    constructor: (data) ->
      super(data)

      @created_at = moment.parseZone(@created_at)
      @created_at.tz(@time_zone) if @time_zone

    getItems: ->
      deferred = $q.defer()
      @_data.$get('purchase_items').then (items) ->
        @items = for item in items
          new BBModel.Member.PurchaseItem(item)
        deferred.resolve(@items)
      deferred.promise