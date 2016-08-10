
angular.module('BB.Models').factory "EventChainCollectionModel", ($q, BBModel, BaseCollectionModel) ->

  class EventChainCollection extends BaseCollectionModel


    constructor: (resource) ->
      super(resource)
      @initialise('event_chains', BBModel.EventChain)


    initialise: (key, model) ->
      super(key, model)


    getNext: () ->
      super(BBModel.EventChainCollection)
