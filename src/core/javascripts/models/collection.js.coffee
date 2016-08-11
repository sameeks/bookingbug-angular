'use strict';

angular.module('BB.Models').factory "BaseCollectionModel", ($q, BBModel, BaseModel) ->

  class BaseCollection extends BaseModel


    constructor: (resource) ->
      super(resource)

      @total_items = resource.total_entries
      @items = []


    initialise: (key, model) ->

      deferred = $q.defer()

      if key and model and angular.isObject(@)
        
        @$get(key).then (items) =>

          @items = (new model(item) for item in items)
          deferred.resolve(@)

      else if angular.isArray(@)

        @items = (new model(item) for item in items)
        deferred.resolve(@)

       @promise = deferred.promise


    getNext: (model) ->

      deferred = $q.defer()

      if @$has('next')

        @$get('next', {}).then (resource) =>
          collection = new model(resource)
          collection.promise.then (collection) ->
            deferred.resolve(collection)
        , () ->
          deferred.reject()

      else
        deferred.reject()

      return deferred.promise
