'use strict'

angular.module('BB.Models').factory "MembershipLevelModel", ($q, BBModel, BaseModel, MembershipLevelsService) ->

  class MembershipLevel extends BaseModel

    $getMembershipLevels: (company) ->
      MembershipLevelsService.getMembershipLevels(company)

