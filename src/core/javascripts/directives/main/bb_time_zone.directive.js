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
    .directive('bbTimeZoneName', (bbTimeZone, CompanyStoreService) => {
        return {
            restrict: 'A',
            controllerAs: '$tzCtrl',
            templateUrl: '_time_zone_info.html',
            controller() {

                let company_time_zone = CompanyStoreService.time_zone;

                this.time_zone_name = moment().tz(company_time_zone).format('zz');

                if (!bbi18nOptions.use_browser_time_zone && bbTimeZone.displayTimeZone !== company_time_zone) {
                    this.is_time_zone_diff = true;
                }
            }
        };
    }
);
