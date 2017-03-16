/***
 * @ngdoc directive
 * @name BB.Directives:bbTimeZoneName
 * @restrict A
 * @description
 * Timezone name helper
 * @param {String} time_zone_name The name of the time zone
 * @param {Boolean} is_time_zone_diff Indicates if the users time zone is different to the company time zone
 * @example
 * <div bb-time-zone-name></div>
 * @example_result
 * <span bb-time-zone-name>All times are shown in British Summer Time.</span>
 *///
angular
    .module('BB.Directives')
    .directive('bbTimeZoneName', (CompanyStoreService, bbi18nOptions) => {
        return {
            restrict: 'A',
            controllerAs: '$tzCtrl',
            templateUrl: '_time_zone_name.html',
            controller() {

                const company_time_zone = CompanyStoreService.time_zone;

                this.time_zone_name = bbi18nOptions.display_time_zone;

                if (this.time_zone_name !== company_time_zone) {
                    this.is_time_zone_diff = true;
                }
            }
        };
    }
);
