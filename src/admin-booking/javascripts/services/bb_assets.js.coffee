'use strict'

###
* @ngdoc service
* @name BBAdminBooking.service:BBAssets
* @description
* Gets all the resources for the callendar
###
angular.module('BBAdminBooking').factory 'BBAssets', ($q, BBModel) ->
  return (company)->
    delay = $q.defer()
    promises = []
    assets   = []
    # If company setup with people add people to select
    if company.$has('people')
      promises.push BBModel.Admin.Person.$query({company: company, embed: "immediate_schedule"}).then (people) ->
        for p in people
          p.title      = p.name
          # this is required in case the item comes from the cache and the item.id has been manipulated
          if !p.identifier?
            p.identifier = p.id + '_p'
          p.group      = 'Staff'

        assets = _.union assets, people

    # If company is setup with resources add them to select
    if company.$has('resources')
      promises.push BBModel.Admin.Resource.$query({company: company, embed: "immediate_schedule"}).then (resources) ->
        for r in resources
          r.title      = r.name
          # this is required in case the item comes from the cache and the item.id has been manipulated
          if !r.identifier?
            r.identifier = r.id + '_r'
          r.group      = 'Resources '

        assets = _.union assets, resources

    # Resolve all promises together
    $q.all(promises).then ->
      assets.sort (a,b) ->
        if a.type == "person" && b.type == "resource"
          return -1
        if a.type == "resource" && b.type == "person"
          return 1
        if a.name > b.name
          return 1
        if a.name < b.name
          return -1
        return 0
      delay.resolve(assets);

    delay.promise

