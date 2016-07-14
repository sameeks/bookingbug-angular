'use strict'

angular.module('BB.Models').factory "Admin.ClientModel", (ClientModel, $q, BBModel) ->

  class Admin_Client extends ClientModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      company = params.company
      defer = $q.defer()
      if company.$has('client')
        company.$get('client').then (collection) ->
          collection.$get('clients').then (clients) ->
            models = (new BBModel.Admin.Client(c) for c in clients)
            defer.resolve(models)
          , (err) ->
            defer.reject(err)
        , (err) ->
          defer.reject(err)
      else
        $log.warn('company has no client link')
        defer.reject('company has no client link')
      defer.promise

