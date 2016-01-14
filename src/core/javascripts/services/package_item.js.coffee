angular.module('BB.Services').factory "PackageItemService", ($q, BBModel) ->

  query: (company) ->
    deferred = $q.defer()
    if !company.$has('packages')
      deferred.reject("No packages found")
    else
      company.$get('packages').then (resource) ->
        resource.$get('packages').then (package_items) ->
          deferred.resolve(new BBModel.PackageItem(i) for i in package_items)
      , (err) ->
        deferred.reject(err)

    deferred.promise

  getPackageServices: (package_item) ->
    deferred = $q.defer()
    if !package_item.$has('services')
      deferred.reject("No services found")
    else
      package_item.$get('services').then (services) ->
        deferred.resolve((new BBModel.Service(s) for s in services))
      , (err) =>
        deferred.reject(err)

    deferred.promise
