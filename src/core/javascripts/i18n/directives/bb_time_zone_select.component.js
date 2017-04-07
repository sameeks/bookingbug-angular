(function () {

    'use strict';

    /**
     * @ngdoc component
     * @name BBAdminDashboard.bbTimeZoneSelect
     *
     * @description
     * TimeZone Select
     *
     * @example
     * <example>
     *   <bb-time-zone-select moment-names="true" limit-time-zones="'Europe'" exclude="'Berlin'"></bb-time-zone-select>
     *   <bb-time-zone-select moment=names="true" limit-time-zones="['Asia', 'America']"></bb-time-zone-select>
     *   <bb-time-zone-select moment-names="true" format="'(GMT offset-hours) location (tz-code)'"
     * </example>
     */

    angular
        .module('BB.i18n')
        .component('bbTimeZoneSelect', {
            templateUrl: 'i18n/_bb_timezone_select.html',
            bindings: {
                hideToggle: '<',
                useMomentNames: '<',
                limitTimeZones: '<',
                excludeTimeZones: '<',
                format: '<'
            },
            controller: TimeZoneSelectCtrl,
            controllerAs: '$bbTimeZoneSelectCtrl'
        });

    function TimeZoneSelectCtrl($rootScope, $scope, $localStorage, bbTimeZone, bbTimeZoneOptions, CompanyStoreService, bbi18nOptions) {
        'ngInject';

        const ctrl = this;

        ctrl.timeZones = [];
        ctrl.isAutomaticTimeZone = false;
        ctrl.selectedTimeZone = null;

        ctrl.$onInit = function () {
            ctrl.timeZones = bbTimeZoneOptions.generateTimeZoneList(ctrl.useMomentNames, ctrl.limitTimeZones, ctrl.excludeTimeZones, ctrl.format); //TODO should be more customisable
            ctrl.updateTimeZone = updateTimeZone;
            ctrl.automaticTimeZoneToggle = automaticTimeZoneToggle;
            if (bbi18nOptions.use_browser_time_zone && $localStorage.getItem('bbTimeZone') === undefined) ctrl.isAutomaticTimeZone = true;
            $rootScope.connection_started ? $rootScope.connection_started.then(determineTimeZone) : determineTimeZone();
        };

        function determineTimeZone () {
            bbTimeZone.determineTimeZone();
            ctrl.selectedTimeZone = _.find(ctrl.timeZones, (tz) => tz.value === bbTimeZone.getDisplayTimeZone());
        }

        function automaticTimeZoneToggle () {
            const timeZone = ctrl.isAutomaticTimeZone ? moment.tz.guess() : bbTimeZone.findTimeZoneKey(CompanyStoreService.time_zone);
            updateTimeZone(timeZone, false);
            $scope.$broadcast('UISelect:closeSelect');
        }

        function updateTimeZone (timeZone, updateLocalStorage) {
            ctrl.selectedTimeZone = _.find(ctrl.timeZones, (tz) => tz.value === timeZone);
            bbTimeZone.setDisplayTimeZone(timeZone, ctrl.useMomentNames, updateLocalStorage);
            $rootScope.$broadcast('BBTimeZoneOptions:timeZoneChanged', timeZone);
        }

        $scope.$on('BBLanguagePicker:languageChanged', languageChangedHandler);

        function languageChangedHandler () {
            ctrl.$onInit();
        }

    }

})();
