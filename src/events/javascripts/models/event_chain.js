angular.module('BB.Models').factory("AdminEventChainModel", ($q, BBModel,
                                                             BaseModel, EventChainService) =>

    class Admin_EventChain extends BaseModel {

        constructor(data) {
            super(data);
        }

        static $query(params) {
            return EventChainService.query(params);
        }
    }
);

