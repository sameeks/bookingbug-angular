'use strict';

angular.module('BB.Models').factory "BaseCollectionModel", ($q, BBModel, BaseModel) ->

  class BaseCollection extends BaseModel


    # TODO write base collection and then extend it where needed 
    # extended classe will know the resource name (key) and the model they need to use to instanite the object 

    # TODO mapping bookings to model type
    #
    # inoput one: the array and model to instantiate
    # input two: the resource
    constructor: (resource) ->

      @total_items = @total_entries 


    # getNextPage: (params) =>

    #   deferred = $q.defer()

    #   @$get('next', params).then (collection) ->
    #     deferred.resolve(new BBModel.BBCollection(collection))
    #   , () ->
    #     deferred.reject()

    #   return deferred.promise


    initialise: (key, model) ->

      debugger

      @promise = $q.defer()

      if key and model and angular.isObject(@)
        
        @$get(key).then (items) ->
          @items = (new model(item) for item in items)
          @promise.resolve(@)

      else if angular.isArray(@)

        @items = (new model(item) for item in items)
        @promise.resolve(@)

      return @promise.promise


angular.module('BB.Models').factory "Member.MemberBookingCollectionModel", ($q, BBModel, BaseModel) ->

  class Member_MemberBookingCollection extends BaseCollection


    # TODO write base collection and then extend it where needed 
    # extended classe will know the resource name (key) and the model they need to use to instanite the object 

    # TODO mapping bookings to model type
    #
    # inoput one: the array and model to instantiate
    # input two: the resource
    constructor: (resource) ->

      debugger

      super(resource)

      @initialse('bookings', BBModel.Member.Booking)

