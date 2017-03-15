(function () {

    'use strict';

    /**
     * @ngdoc component
     * @name BBAdminDashboard.bbTimeZoneOptions
     *
     * @description
     * TimeZone options
     *
     * @example
     * <example>
     *   <time-zone-options restrict-region="'Europe'"></time-zone-options>
     *   <time-zone-options restrict-region="['Asia', 'America']"></time-zone-options>
     * </example>
     */

     angular
         .module('BBAdminDashboard')
         .component('bbTimeZoneOptions', {
             templateUrl: 'core/_bb-timezone-options.html',
             bindings: {
                 restrictRegion: '<'
             },
             controller: TimeZoneOptionsCtrl,
             controllerAs: '$bbTimeZoneOptionsCtrl'
         });

    function TimeZoneOptionsCtrl ($scope, $rootScope, $localStorage, bbTimeZone, GeneralOptions, CompanyStoreService, bbi18nOptions) {
        'ngInject';

        const ctrl = this;

        ctrl.timezones = [];
        ctrl.automaticTimeZone = false;
        ctrl.selectedTimeZone = null;

        ctrl.$onInit = function() {
            ctrl.timezones = bbTimeZone.generateTimeZoneList(ctrl.restrictRegion);
            ctrl.setNewTimeZone = setNewTimeZone;
            ctrl.automaticTimeZoneToggle = automaticTimeZoneToggle;
            setDefaults();
        };

        function automaticTimeZoneToggle () {
            let tz;

            if (ctrl.automaticTimeZone) {
                tz = moment.tz.guess();
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(tz);
                ctrl.setNewTimeZone(tz, true);
            }

            if (!ctrl.automaticTimeZone) {
                tz = CompanyStoreService.time_zone;
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(tz);
                resetTimeZone(tz);
            }

            $scope.$broadcast('UISelect:closeSelect');

        }

        function setNewTimeZone (timezone, setTzAutomatically) {
            $localStorage.setItem('selectedTimeZone', timezone);
            bbTimeZone.updateDisplayTimeZone(timezone);
            GeneralOptions.custom_time_zone = CompanyStoreService.time_zone !== timezone ? true : false;
            bbi18nOptions.use_browser_time_zone = setTzAutomatically ? setTzAutomatically : false;
            moment.tz.setDefault(timezone);
            $rootScope.$emit('BBTimeZoneOptions:timeZoneChanged', timezone);
        }

        function resetTimeZone (timezone) {
            $localStorage.removeItem('selectedTimeZone');
            bbTimeZone.updateDisplayTimeZone();
            GeneralOptions.custom_time_zone = bbi18nOptions.use_browser_time_zone = false;
            moment.tz.setDefault(timezone);
            $rootScope.$emit('BBTimeZoneOptions:timeZoneChanged', null);
        }

        function setDefaults () {
            const timezone = $localStorage.getItem('selectedTimeZone');
            if (timezone) {
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(timezone);
                ctrl.automaticTimeZone = moment.tz.guess() === timezone ? true : false;
            } else {
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(CompanyStoreService.time_zone);
            }
        }
    }

})();
