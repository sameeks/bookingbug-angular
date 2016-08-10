
angular.module('BB.Models').factory "EventCollectionModel", ($q, BBModel, BaseCollectionModel) ->

  class EventCollection extends BaseCollectionModel


    constructor: (resource) ->
      super(resource)
      @initialise('events', BBModel.Event)


    initialise: (key, model) ->
      super(key, model)


    getNext: () ->
      super(BBModel.EventCollection)
