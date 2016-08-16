'use strict'

angular.module('BB.Services').factory "MembershipLevelsService", ($q, BBModel) ->

 getMembershipLevels: (company) ->
    deferred = $q.defer()
    company.$get("member_levels").then (resource) ->
    	resource.$get('membership_levels').then (membership_levels) =>
      levels = (new BBModel.MembershipLevel(level) for level in membership_levels)
      deferred.resolve(levels)
    , (err) =>
      deferred.reject(err)
    deferred.promise

