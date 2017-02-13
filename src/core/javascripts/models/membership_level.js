// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("MembershipLevelModel", ($q, BBModel, BaseModel, MembershipLevelsService) =>

  class MembershipLevel extends BaseModel {

    $getMembershipLevels(company) {
      return MembershipLevelsService.getMembershipLevels(company);
    }
  }
);

