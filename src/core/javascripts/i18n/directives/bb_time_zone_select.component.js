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

        this.timeZones = [];
        this.isAutomaticTimeZone = false;
        this.selectedTimeZone = null;

        this.$onInit = () => {
            this.timeZones = bbTimeZoneOptions.generateTimeZoneList(this.useMomentNames, this.limitTimeZones, this.excludeTimeZones, this.format); //TODO should be more customisable
            this.updateTimeZone = updateTimeZone;
            this.automaticTimeZoneToggle = automaticTimeZoneToggle;

            if (bbi18nOptions.use_browser_time_zone && ($localStorage.getObject('bbTimeZone').displayTimeZone === undefined)) this.isAutomaticTimeZone = true;
            if ($localStorage.getObject('bbTimeZone').useBrowserTimeZone) this.isAutomaticTimeZone = true;
            $rootScope.connection_started ? $rootScope.connection_started.then(determineTimeZone) : determineTimeZone();
        };

        const determineTimeZone = () => {
            bbTimeZone.determineTimeZone();
            this.selectedTimeZone = _.find(this.timeZones, (tz) => tz.value === bbTimeZone.getDisplayTimeZone());
        };

        const automaticTimeZoneToggle = () => {
            const timeZone = this.isAutomaticTimeZone ? moment.tz.guess() : bbTimeZone.getTimeZoneKey(CompanyStoreService.time_zone);
            updateTimeZone(timeZone, this.isAutomaticTimeZone);
            $scope.$broadcast('UISelect:closeSelect');
        };

        const updateTimeZone = (timeZone, isAutomaticTimeZone = false, updateLocalStorage = true) => {
            this.selectedTimeZone = _.find(this.timeZones, (tz) => tz.value === timeZone);
            bbTimeZone.setDisplayTimeZone(timeZone, this.useMomentNames, isAutomaticTimeZone, updateLocalStorage);
            $rootScope.$broadcast('BBTimeZoneOptions:timeZoneChanged', timeZone);
        };

        $scope.$on('BBLanguagePicker:languageChanged', languageChangedHandler);

        const languageChangedHandler = () => {
            this.$onInit();
        };

    }

})();
