(function () {

    'use strict';

    /**
     * @ngdoc component
     * @name BBAdminDashboard.timezoneOptions
     *
     * @description
     * Timezone options
     *
     * @example
     * <example>
     *   <timezone-options restrict-region="'Europe'"></timezone-options>
     *   <timezone-options restrict-region="['Asia', 'America']"></timezone-options>
     * </example>
     */

     angular
         .module('BBAdminDashboard')
         .component('bbTimezoneOptions', {
             templateUrl: 'core/_bb-timezone-options.html',
             bindings: {
                 restrictRegion: '<'
             },
             controller: TimezoneOptionsCtrl,
             controllerAs: '$bbTimezoneOptionsCtrl'
         });

    function TimezoneOptionsCtrl ($scope, $rootScope, $localStorage, TimezoneOptions, GeneralOptions, CompanyStoreService) {
        'ngInject';

        const ctrl = this;

        ctrl.timezones = [];
        ctrl.automaticTimezone = false;
        ctrl.selectedTimezone = null;

        ctrl.$onInit = function() {
            ctrl.timezones = TimezoneOptions.generateTimezoneList(ctrl.restrictRegion);
            ctrl.setNewTimezone = setNewTimezone;
            ctrl.automaticTimezoneToggle = automaticTimezoneToggle;
            setDefaults();
        };

        function automaticTimezoneToggle () {
            let tz;

            if (ctrl.automaticTimezone) {
                tz = moment.tz.guess();
                ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(tz);
                ctrl.setNewTimezone(tz, true);
            }

            if (!ctrl.automaticTimezone) {
                tz = CompanyStoreService.time_zone;
                ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(tz);
                resetTimezone(tz);
            }

            $scope.$broadcast('UISelect:closeSelect');

        }

        function setNewTimezone (timezone, setTzAutomatically) {
            $localStorage.setItem('selectedTimezone', timezone);
            GeneralOptions.display_time_zone = timezone;
            GeneralOptions.custom_time_zone = CompanyStoreService.time_zone !== timezone ? true : false;
            GeneralOptions.set_time_zone_automatically = setTzAutomatically ? setTzAutomatically : false;
            moment.tz.setDefault(timezone);
            $rootScope.$emit('BBTimezoneOptions:timezoneChanged', timezone);
        }

        function resetTimezone (timezone) {
            $localStorage.removeItem('selectedTimezone');
            GeneralOptions.display_time_zone = null;
            GeneralOptions.custom_time_zone = GeneralOptions.set_time_zone_automatically = false;
            moment.tz.setDefault(timezone);
            $rootScope.$emit('BBTimezoneOptions:timezoneChanged', null);
        }

        function setDefaults () {
            const timezone = $localStorage.getItem('selectedTimezone');
            if (timezone) {
                ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(timezone);
                ctrl.automaticTimezone = moment.tz.guess() === timezone ? true : false;
            } else {
                ctrl.selectedTimezone = TimezoneOptions.mapTimezoneForDisplay(CompanyStoreService.time_zone);
            }
        }
    }

})();
