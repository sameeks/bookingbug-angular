// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("MembershipLevelsService", ($q, BBModel) =>

    ({
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
    })
);

