'use strict'

angular.module('BB.Models').factory "Admin.ClientModel", (ClientModel, $q, BBModel, $log,$window,ClientCollections) ->

  class Admin_Client extends ClientModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      company = params.company
      defer = $q.defer()

      if company.$has('client')

        if params.flush
          company.$flush('client', params)

        company.$get('client', params).then (resource) ->
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



