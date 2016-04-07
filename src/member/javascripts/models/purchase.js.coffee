
###**
* @ngdoc service
* @name BB.Models:MemberPurchase
*
* @description
* Representation of an Purchase Object
####

angular.module("BB.Models").factory "Member.PurchaseModel",
($q, MemberPurchaseService, BBModel, BaseModel) ->

  class Member_Purchase extends BaseModel

    constructor: (data) ->
      super(data)

      @created_at = moment.parseZone(@created_at)
      @created_at.tz(@time_zone) if @time_zone

    ###**
    * @ngdoc method
    * @name getItems
    * @methodOf BB.Models:MemberPurchase
    * @description
    * Gets the pruchase items
    *
    * @returns {promise} A returned promise
    ###
    getItems: ->
      deferred = $q.defer()
      @_data.$get('purchase_items').then (items) ->
        @items = for item in items
          new BBModel.Member.PurchaseItem(item)
        deferred.resolve(@items)
      deferred.promise

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:MemberPurchase
    * @description
    * Static functions that loads an array of total purchases.
    *
    * @returns {promise} A promise that on success will return an array of PurchaseTotal objects
    ###
    @$query: (member, params) ->
      MemberPurchaseService.query(member, params)
