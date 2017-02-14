// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc service
 * @name BBAdminBooking.service:BBAssets
 * @description
 * Gets all the resources for the callendar
 */
let BBAssets = function (BBModel, $q, $translate) {
    'ngInject';

    let getAssets = function (company) {
        let delay = $q.defer();
        let promises = [];
        let assets = [];
        // If company setup with people add people to select
        if (company.$has('people')) {
            promises.push(BBModel.Admin.Person.$query({company, embed: "immediate_schedule"}).then(function (people) {
                    for (let p of Array.from(people)) {
                        p.title = p.name;
                        // this is required in case the item comes from the cache and the item.id has been manipulated
                        if (p.identifier == null) {
                            p.identifier = p.id + '_p';
                        }
                        p.group = $translate.instant('ADMIN_BOOKING.ASSETS.STAFF_GROUP_LABEL');
                    }


                    return assets = _.union(assets, people);
                })
            );
        }

        // If company is setup with resources add them to select
        if (company.$has('resources')) {
            promises.push(BBModel.Admin.Resource.$query({
                    company,
                    embed: "immediate_schedule"
                }).then(function (resources) {
                    for (let r of Array.from(resources)) {
                        r.title = r.name;
                        // this is required in case the item comes from the cache and the item.id has been manipulated
                        if (r.identifier == null) {
                            r.identifier = r.id + '_r';
                        }
                        r.group = $translate.instant('ADMIN_BOOKING.ASSETS.RESOURCES_GROUP_LABEL');
                    }

                    return assets = _.union(assets, resources);
                })
            );
        }

        // Resolve all promises together
        $q.all(promises).then(function () {
            assets.sort(function (a, b) {
                if ((a.type === "person") && (b.type === "resource")) {
                    return -1;
                }
                if ((a.type === "resource") && (b.type === "person")) {
                    return 1;
                }
                if (a.name > b.name) {
                    return 1;
                }
                if (a.name < b.name) {
                    return -1;
                }
                return 0;
            });
            return delay.resolve(assets);
        });

        return delay.promise;
    };

    return {
        getAssets
    };
};

angular.module('BBAdminBooking').factory('BBAssets', BBAssets);
