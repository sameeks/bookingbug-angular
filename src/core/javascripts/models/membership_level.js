angular.module('BB.Models').factory("MembershipLevelModel", ($q, BBModel, BaseModel, MembershipLevelsService) =>

    class MembershipLevel extends BaseModel {

        $getMembershipLevels(company) {
            return MembershipLevelsService.getMembershipLevels(company);
        }
    }
);

