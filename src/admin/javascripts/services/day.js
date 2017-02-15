// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('AdminDayService', ($q, $window, halClient, BBModel, UriTemplate) => {

        return {
            query(prms) {
                let url = "";
                if (prms.url) {
                    ({url} = prms);
                }
                let href = url + "/api/v1/{company_id}/day_data{?month,week,date,edate,event_id,service_id}";

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                let deferred = $q.defer();
                halClient.$get(uri, {}).then(found => {
                        if (found.items) {
                            let mdays = [];
                            // it has multiple days of data
                            for (let item of Array.from(found.items)) {
                                halClient.$get(item.uri).then(function (data) {
                                    let days = [];
                                    for (let i of Array.from(data.days)) {
                                        if (i.type === prms.item) {
                                            days.push(new BBModel.Day(i));
                                        }
                                    }
                                    let dcol = new $window.Collection.Day(data, days, {});
                                    return mdays.push(dcol);
                                });
                            }
                            return deferred.resolve(mdays);
                        }
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );

                return deferred.promise;
            }
        };
    }
);

