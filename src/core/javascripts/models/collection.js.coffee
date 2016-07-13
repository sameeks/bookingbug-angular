'use strict'

angular.module('BB.Models').factory "BBCollectionModel", ($q, BBModel, BaseModel) ->

  class BBCollection extends BaseModel


    getNextPage: (params) =>

      deferred = $q.defer()

      @$get('next', params).then (collection) ->
        deferred.resolve(new BBModel.BBCollection(collection))
      , () ->
        deferred.reject()

      return deferred.promise
