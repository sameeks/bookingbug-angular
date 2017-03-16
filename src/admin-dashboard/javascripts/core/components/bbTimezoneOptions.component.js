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
         .module('BBAdminDashboard')
         .component('bbTimeZoneOptions', {
             templateUrl: 'core/_bb-timezone-options.html',
             bindings: {
                 restrictRegion: '<'
             },
             controller: TimeZoneOptionsCtrl,
             controllerAs: '$bbTimeZoneOptionsCtrl'
         });

    function TimeZoneOptionsCtrl ($scope, $rootScope, bbTimeZone, CompanyStoreService) {
        'ngInject';

        const ctrl = this;

        ctrl.timeZones = [];
        ctrl.automaticTimeZone = false;
        ctrl.selectedTimeZone = null;

        ctrl.$onInit = function() {
            ctrl.timeZones = bbTimeZone.generateTimeZoneList(ctrl.restrictRegion);
            ctrl.setNewTimeZone = setNewTimeZone;
            ctrl.automaticTimeZoneToggle = automaticTimeZoneToggle;
            setDefaults();
        };

        function automaticTimeZoneToggle () {
            let tz;

            if (ctrl.automaticTimeZone) {
                tz = moment.tz.guess();
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(tz);
                setNewTimeZone(tz);
            }

            if (!ctrl.automaticTimeZone) {
                tz = CompanyStoreService.time_zone;
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(tz);
                resetTimeZone(tz);
            }

            $scope.$broadcast('UISelect:closeSelect');

        }

        function setNewTimeZone (timeZone) {
            bbTimeZone.updateDefaultTimeZone(timeZone, 'setItem');
            $rootScope.$emit('BBTimeZoneOptions:timeZoneChanged', timeZone);
        }

        function resetTimeZone (timeZone) {
            bbTimeZone.updateDefaultTimeZone(timeZone, 'removeItem');
            $rootScope.$emit('BBTimeZoneOptions:timeZoneChanged', null);
        }

        function setDefaults () {
            const timeZone = bbTimeZone.getTimeZoneLs();
            if (timeZone) {
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(timeZone);
                ctrl.automaticTimeZone = moment.tz.guess() === timeZone ? true : false;
            } else {
                ctrl.selectedTimeZone = bbTimeZone.mapTimeZoneForDisplay(CompanyStoreService.time_zone);
            }
        }
    }

})();
