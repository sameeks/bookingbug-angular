angular.module('BB.Services').factory("MembershipLevelsService", ($q, BBModel) => {

        return {
            getMembershipLevels(company) {
                let deferred = $q.defer();
                company.$get("member_levels").then(resource =>
                        resource.$get('membership_levels').then(membership_levels => {
                                let levels = (Array.from(membership_levels).map((level) => new BBModel.MembershipLevel(level)));
                                return deferred.resolve(levels);
                            }
                        )

                    , err => {
                        return deferred.reject(err);
                    }
                );
                return deferred.promise;
            }
        };
    }
);

