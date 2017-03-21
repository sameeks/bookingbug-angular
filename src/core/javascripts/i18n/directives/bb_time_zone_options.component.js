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
     *   <bb-time-zone-options restrict-region="'Europe'"></bb-time-zone-options>
     *   <bb-time-zone-options restrict-region="['Asia', 'America']"></bb-time-zone-options>
     * </example>
     */

     angular
         .module('BB.i18n')
         .component('bbTimeZoneOptions', {
             templateUrl: 'i18n/_bb_timezone_options.html',
             bindings: {
                 restrictRegion: '<'
             },
             controller: TimeZoneOptionsCtrl,
             controllerAs: '$bbTimeZoneOptionsCtrl'
         });

    function TimeZoneOptionsCtrl ($scope, $rootScope, bbTimeZone, bbTimeZoneOptions, CompanyStoreService, bbi18nOptions) {
        'ngInject';

        const ctrl = this;

        ctrl.timeZones = [];
        ctrl.automaticTimeZone = false;
        ctrl.selectedTimeZone = null;

        ctrl.$onInit = function() {
            ctrl.timeZones = bbTimeZoneOptions.generateTimeZoneList(ctrl.restrictRegion);
            ctrl.updateTimeZone = updateTimeZone;
            ctrl.automaticTimeZoneToggle = automaticTimeZoneToggle;
            setDefaults();
        };

        function automaticTimeZoneToggle () {
            let tz;

            if (ctrl.automaticTimeZone) {
                tz = moment.tz.guess();
                updateTimeZone(tz, 'setItem');
            }

            if (!ctrl.automaticTimeZone) {
                tz = CompanyStoreService.time_zone;
                updateTimeZone(tz, 'removeItem');
            }

            $scope.$broadcast('UISelect:closeSelect');

        }

        function updateTimeZone (timeZone, localStorageAction) {
            ctrl.selectedTimeZone = bbTimeZoneOptions.mapTimeZoneForDisplay(timeZone);
            bbTimeZone.updateDefaultTimeZone(timeZone, localStorageAction);
            $rootScope.$emit('BBTimeZoneOptions:timeZoneChanged', timeZone);
        }

        function setDefaults () {
            const timeZone = bbTimeZone.getTimeZoneLs();
            const browserTimeZone = bbi18nOptions.use_browser_time_zone;

            if (timeZone) {
                ctrl.selectedTimeZone = bbTimeZoneOptions.mapTimeZoneForDisplay(timeZone);
                return;
            }

            if (browserTimeZone) {
                ctrl.automaticTimeZone = true;
                ctrl.selectedTimeZone = bbTimeZoneOptions.mapTimeZoneForDisplay(moment.tz.guess());
                return;
            }

            ctrl.selectedTimeZone = bbTimeZoneOptions.mapTimeZoneForDisplay(CompanyStoreService.time_zone);
        }
    }

})();
