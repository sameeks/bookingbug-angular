// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Services').factory("DayService", ($q, BBModel) => {

        return {
            query(prms) {

                let deferred = $q.defer();

                if (prms.cItem.days_link) {

                    let extra = {};
                    extra.month = prms.month;
                    extra.date = prms.date;
                    extra.edate = prms.edate;
                    if (prms.people_ids) {
                        extra.people_ids = prms.people_ids;
                    }
                    if (prms.resource_ids) {
                        extra.resource_ids = prms.resource_ids;
                    }
                    if (prms.person_group_id) {
                        extra.person_group_id = prms.person_group_id;
                    }

                    prms.cItem.days_link.$get('days', extra).then(found => {

                            let afound = found.days;
                            let days = [];

                            for (let i of Array.from(afound)) {

                                if (i.type === prms.item) {
                                    days.push(new BBModel.Day(i));
                                }
                            }

                            return deferred.resolve(days);
                        }

                        , err => {
                            return deferred.reject(err);
                        }
                    );

                } else {

                    deferred.reject("No Days Link found");
                }

                return deferred.promise;
            }
        };

    }
);
