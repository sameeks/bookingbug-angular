'use strict'

angular.module('BB.Models').factory "Admin.EventGroupModel", ($q, BBModel,
  BaseModel, EventGroupService) ->

  class Admin_EventGroup extends BaseModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      EventGroupService.query(params)

