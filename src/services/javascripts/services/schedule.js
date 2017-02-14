// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('AdminScheduleService', function ($q,
                                                                             BBModel, ScheduleRules, BBAssets) {

    let schedule_cache = {};

    ({
        query(params) {
            let {company} = params;
            let defer = $q.defer();
            company.$get('schedules').then(collection =>
                    collection.$get('schedules').then(function (schedules) {
                            let models = (Array.from(schedules).map((s) => new BBModel.Admin.Schedule(s)));
                            return defer.resolve(models);
                        }
                        , err => defer.reject(err))

                , err => defer.reject(err));
            return defer.promise;
        },


        delete(schedule) {
            let deferred = $q.defer();
            schedule.$del('self').then(schedule => {
                    schedule = new BBModel.Admin.Schedule(schedule);
                    return deferred.resolve(schedule);
                }
                , err => {
                    return deferred.reject(err);
                }
            );

            return deferred.promise;
        },

        update(schedule) {
            let deferred = $q.defer();
            return schedule.$put('self', {}, schedule.getPostData()).then(c => {
                    schedule = new BBModel.Admin.Schedule(c);
                    return deferred.resolve(schedule);
                }
                , err => {
                    return deferred.reject(err);
                }
            );
        }
    });


    let cacheDates = function (asset, dates) {
        if (!schedule_cache[asset.self]) {
            schedule_cache[asset.self] = {};
        }
        return (() => {
            let result = [];
            for (let k in dates) {
                let v = dates[k];
                result.push(schedule_cache[asset.self][k] = v);
            }
            return result;
        })();
    };

    let getCacheDates = function (asset, start, end) {

        if (!schedule_cache[asset.self]) {
            return false;
        }
        let st = moment(start);
        let en = moment(end);
        let curr = moment(start);
        let dates = [];

        let asset_cache = schedule_cache[asset.self];
        while (curr.unix() < end.unix()) {
            let test = curr.format('YYYY-MM-DD');
            if (!asset_cache[test]) {
                return false;
            }
            dates[test] = asset_cache[test];
            curr = curr.add(1, 'day');
        }

        return dates;
    };

    // return a promise to resovle any existing schedule cahcing stuff
    let loadScheduleCaches = function (assets) {
        let proms = [];
        for (let asset of Array.from(assets)) {
            if (asset.$has('immediate_schedule')) {
                (asset => {
                    let prom = asset.$get('immediate_schedule');
                    proms.push(prom);
                    return prom.then(schedules => cacheDates(asset, schedules.dates));
                })(asset);
            }
        }

        let fin = $q.defer();
        if (proms.length > 0) {
            $q.all(proms).then(() => fin.resolve());
        } else {
            fin.resolve();
        }
        return fin.promise;
    };


    return {
        mapAssetsToScheduleEvents(start, end, assets) {
            let assets_with_schedule = _.filter(assets, asset => asset.$has('schedule'));

            return _.map(assets_with_schedule, function (asset) {

                let events, rules;
                let found = getCacheDates(asset, start, end);
                if (found) {
                    rules = new ScheduleRules(found);
                    events = rules.toEvents();
                    _.each(events, function (e) {
                        e.resourceId = parseInt(asset.id) + "_" + asset.type[0];
                        e.title = asset.name;
                        e.start = moment(e.start);
                        e.end = moment(e.end);
                        return e.rendering = "background";
                    });
                    let prom = $q.defer();
                    prom.resolve(events);
                    return prom.promise;
                } else {
                    let params = {
                        start_date: start.format('YYYY-MM-DD'),
                        end_date: end.format('YYYY-MM-DD')
                    };

                    return asset.$get('schedule', params).then(function (schedules) {
                        // cacheDates(asset, schedules.dates)
                        rules = new ScheduleRules(schedules.dates);
                        events = rules.toEvents();
                        _.each(events, function (e) {
                            e.resourceId = parseInt(asset.id) + "_" + asset.type[0];
                            e.title = asset.name;
                            e.start = moment(e.start);
                            e.end = moment(e.end);
                            return e.rendering = "background";
                        });
                        return events;
                    });
                }
            });
        },

        getAssetsScheduleEvents(company, start, end, filtered, requested) {
            if (filtered == null) {
                filtered = false;
            }
            if (requested == null) {
                requested = [];
            }
            if (filtered) {
                return loadScheduleCaches(requested).then(() => {
                        return $q.all(this.mapAssetsToScheduleEvents(start, end, requested)).then(schedules => _.flatten(schedules));
                    }
                );
            } else {
                let localMethod = this.mapAssetsToScheduleEvents;
                return BBAssets.getAssets(company).then(assets =>
                    loadScheduleCaches(assets).then(() =>
                        $q.all(localMethod(start, end, assets)).then(schedules => _.flatten(schedules))
                    )
                );
            }
        }
    };
});

