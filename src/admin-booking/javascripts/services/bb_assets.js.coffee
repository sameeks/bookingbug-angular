###
* @ngdoc service
* @name BBAdminBooking.service:BBAssets
* @description
* Gets all the resources for the callendar
###
angular.module('BBAdminBooking').factory 'BBAssets', ['$q', ($q) ->
  return (company)->
    delay = $q.defer()
    promises = []
    assets   = []
    # If company setup with people add people to select
    if company.$has('people')
      promises.push company.getPeoplePromise().then (people)->
        for p in people
          p.title      = p.name
          p.identifier = p.id + '_p'
          p.group      = 'Staff'

        assets = _.union assets, people

    # If company is setup with resources add them to select
    if company.$has('resources')
      promises.push company.getResourcesPromise().then (resources)->
        for r in resources
          r.title      = r.name
          r.identifier = r.id + '_r'
          r.group      = 'Resources '

        assets = _.union assets, resources

    # Resolve all promises together
    $q.all(promises).then ->
      assets = _.sortBy assets, 'name'
      delay.resolve(assets);

    delay.promise  
]