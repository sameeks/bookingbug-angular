
angular.module('BBAdmin.Services').factory 'AdminClientService',  ($q, $window, $rootScope, halClient, ClientCollections, BBModel, UriTemplate) ->

  query: (prms) ->
    if prms.company
      prms.company_id = prms.company.id
    url = ""
    url = $rootScope.bb.api_url if $rootScope.bb.api_url
    href = url + "/api/v1/admin/{company_id}/client{/id}{?page,per_page,filter_by,filter_by_fields,order_by,order_by_reverse,search_by_fields,default_company_id}"

    uri = new UriTemplate(href).fillFromObject(prms || {})
    deferred = $q.defer()

    # If params flush is bool true clear cash before attempting to resolve the resource
    if prms.flush
      halClient.clearCache(uri)

    halClient.$get(uri, {}).then  (resource) =>
      if resource.$has('clients')
        resource.$get('clients').then (items) =>
          people = (new BBModel.Client(i) for i in items)
          clients  = new $window.Collection.Client(resource, people, prms)
          clients.total_entries = resource.total_entries 
          ClientCollections.add(clients)
          deferred.resolve(clients)
      else
        client = new BBModel.Client(resource)
        deferred.resolve(client)
    , (err) =>
      deferred.reject(err)

    deferred.promise


  update: (client) ->
    deferred = $q.defer()
    client.$put('self', {}, client).then (res) =>
      deferred.resolve(new BBModel.Client(res))
    , (err) =>
      deferred.reject(err)
    deferred.promise


