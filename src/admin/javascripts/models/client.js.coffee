'use strict'

angular.module('BB.Models').factory "AdminClientModel", (ClientModel, $q, BBModel, $log,$window,ClientCollections, $rootScope, UriTemplate, halClient) ->

  class Admin_Client extends ClientModel

    constructor: (data) ->
      super(data)
      
    @$post: (client, companyId) ->      
      deferred = $q.defer()
      
      url = $rootScope.bb.api_url + '/api/v1/admin/' + companyId + '/client'
      
      if client? 
        new Error 'missing client data'
      if companyId?
        new Error 'missing companyId'  
        
      halClient.$post(url, {}, client).then (client) ->
        deferred.resolve(client)
      , (err) =>
        deferred.reject(err)
      return deferred.promise

    @$query: (params) ->
      company = params.company
      defer = $q.defer()
      if company.$has('client')

        #if params.flush
        #  company.$flush('client', params)

        # have to use a hard coded api ref for now until all servers also have the {/id} in the href

        url = ""
        url = $rootScope.bb.api_url if $rootScope.bb.api_url
        href = url + "/api/v1/admin/{company_id}/client{/id}{?page,per_page,filter_by,filter_by_fields,order_by,order_by_reverse,search_by_fields,default_company_id}"
        params.company_id = company.id
        uri = new UriTemplate(href).fillFromObject(params || {})

        if params.flush
          halClient.clearCache(uri)

        #company.$get('client', params).then (resource) ->
        halClient.$get(uri, {}).then  (resource) =>
          if resource.$has('clients')
            resource.$get('clients').then (clients) ->
              models = (new BBModel.Admin.Client(c) for c in clients)

              clients  = new $window.Collection.Client(resource, models, params)
              clients.total_entries = resource.total_entries
              ClientCollections.add(clients)
              defer.resolve(clients)
            , (err) ->
              defer.reject(err)
          else
            client = new BBModel.Admin.Client(resource)
            defer.resolve(client)
        , (err) ->
          defer.reject(err)
      else
        $log.warn('company has no client link')
        defer.reject('company has no client link')
      defer.promise



