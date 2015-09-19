'use strict';

angular.module('BB.Models').factory "MembershipLevelModel", ($q, BBModel, BaseModel) ->

  class MembershipLevel extends BaseModel