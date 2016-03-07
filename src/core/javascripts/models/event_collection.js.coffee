'use strict';

angular.module('BB.Models').factory "EventCollectionModel", ($q, BBModel, BaseModel) ->

  class EventCollection extends BaseModel
