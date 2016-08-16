'use strict'

angular.module('BB.Models').factory "Admin.EventChainModel", ($q, BBModel,
  BaseModel, EventChainService) ->

  class Admin_EventChain extends BaseModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      EventChainService.query(params)

