'use strict'

angular.module('BB.Models').factory "AdminEventGroupModel", ($q, BBModel,
  BaseModel, EventGroupService) ->

  class Admin_EventGroup extends BaseModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      EventGroupService.query(params)

