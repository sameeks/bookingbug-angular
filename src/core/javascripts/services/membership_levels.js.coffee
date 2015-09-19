angular.module('BB.Services').factory "AddressListService", ($q) ->
 getMemberShipLevels: (company) ->
    deferred = $q.defer()
    company.$get("member_levels").then (resource) ->
    	resource.$get('membership_levels').then (membership_levels) =>
      levels = (new BBModel.MemberLevel(level) for level in membership_level)
      deferred.resolve(levels)
    , (err) =>
      deferred.reject(err)
    deferred.promise