'use strict'

###
* @ngdoc service
* @name BBAdminBooking.service:BBAssets
* @description
* Gets all the resources for the callendar
###
BBAssets = (BBModel, $q, $translate) ->
  'ngInject'

  getAssets = (company)->
    delay = $q.defer()
    promises = []
    assets = []
    # If company setup with people add people to select
    if company.$has('people')
      promises.push BBModel.Admin.Person.$query({company: company, embed: "immediate_schedule"}).then (people) ->
        for p in people
          p.title = p.name
          # this is required in case the item comes from the cache and the item.id has been manipulated
          if !p.identifier?
            p.identifier = p.id + '_p'
          p.group = $translate.instant('ADMIN_BOOKING.ASSETS.STAFF_GROUP_LABEL')


        assets = _.union assets, people

    # If company is setup with resources add them to select
    if company.$has('resources')
      promises.push BBModel.Admin.Resource.$query({company: company, embed: "immediate_schedule"}).then (resources) ->
        for r in resources
          r.title = r.name
          # this is required in case the item comes from the cache and the item.id has been manipulated
          if !r.identifier?
            r.identifier = r.id + '_r'
          r.group = $translate.instant('ADMIN_BOOKING.ASSETS.RESOURCES_GROUP_LABEL')

        assets = _.union assets, resources

    # Resolve all promises together
    $q.all(promises).then ->
      assets.sort (a, b) ->
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

    return delay.promise

  return {
    getAssets: getAssets
  }

angular.module('BBAdminBooking').factory 'BBAssets', BBAssets
