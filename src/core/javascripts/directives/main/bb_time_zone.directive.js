// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbTimeZone
* @restrict A
* @description
* Timezone name helper
* @param {String} time_zone_name The name of the time zone
* @param {Boolean} is_time_zone_diff Indicates if the users time zone is different to the company time zone
* @example
* <div bb-time-zone></div>
* @example_result
* <span bb-time-zone>All times are shown in British Summer Time.</span>
*///
angular.module('BB.Directives').directive('bbTimeZone', (GeneralOptions, CompanyStoreService) =>
  ({
    restrict: 'A',
    controllerAs: '$tzCtrl',
    templateUrl: '_time_zone_info.html',
    controller() {

      let company_time_zone = CompanyStoreService.time_zone;
      this.time_zone_name   = moment().tz(company_time_zone).format('zz');

      //  if not using local time zone and user time zone is not same as companies
      if (!GeneralOptions.use_local_time_zone && (GeneralOptions.display_time_zone !== company_time_zone)) {
        return this.is_time_zone_diff = true;
      }
    }
  })
); 

