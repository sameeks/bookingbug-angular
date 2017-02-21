angular.module('BBAdmin.Services').factory('AdminTimeService', ($q, $window, halClient, BBModel, UriTemplate) => {

        return {
            query(prms) {
                if (prms.day) {
                    prms.date = prms.day.date;
                }
                if (!prms.edate && prms.date) {
                    prms.edate = prms.date;
                }
                let url = "";
                if (prms.url) {
                    ({url} = prms);
                }
                let href = url + "/api/v1/{company_id}/time_data{?date,event_id,service_id,person_id}";

                let uri = new UriTemplate(href).fillFromObject(prms || {});
                let deferred = $q.defer();
                halClient.$get(uri, {no_cache: false}).then(found => {
                        return found.$get('events').then(events => {
                                let eventItems = [];
                                for (let eventItem of Array.from(events)) {
                                    let event = {};
                                    event.times = [];
                                    event.event_id = eventItem.event_id;
                                    event.person_id = found.person_id;
                                    for (let time of Array.from(eventItem.times)) {
                                        let ts = new BBModel.TimeSlot(time);
                                        event.times.push(ts);
                                    }
                                    eventItems.push(event);
                                }
                                return deferred.resolve(eventItems);
                            }
                        );
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
