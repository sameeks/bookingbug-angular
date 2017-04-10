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
     *   <bb-time-zone-select moment-names="true" limit-time-zones="'Europe'" exclude="['Berlin', 'Zagreb']"></bb-time-zone-select>
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
            this.timeZones = bbTimeZoneOptions.generateTimeZoneList(this.useMomentNames, this.limitTimeZones, this.excludeTimeZones, this.format);
            this.setTimeZone = setTimeZone;
            this.automaticTimeZoneToggle = automaticTimeZoneToggle;
            $rootScope.connection_started ? $rootScope.connection_started.then(determineDefaults) : determineDefaults();
        };

        const determineDefaults = () => {
            const localStorage = $localStorage.getObject('bbTimeZone');
            this.isAutomaticTimeZone = (localStorage.useBrowserTimeZone || bbi18nOptions.use_browser_time_zone);
            this.selectedTimeZone = this.timeZones.find((tz) => tz.value === bbTimeZone.getDisplayTimeZone());
        };

        const automaticTimeZoneToggle = () => {
            let timeZone = this.isAutomaticTimeZone ? moment.tz.guess() : CompanyStoreService.time_zone;
            timeZone = this.useMomentNames ? timeZone : bbTimeZoneOptions.getTimeZoneKey(timeZone);
            setTimeZone(timeZone, this.isAutomaticTimeZone);
            $scope.$broadcast('UISelect:closeSelect');
            bbTimeZone.setLocalStorage({useBrowserTimeZone: this.isAutomaticTimeZone});
        };

        const setTimeZone = (timeZone, isAutomaticTimeZone = false) => {
            bbTimeZone.setDisplayTimeZone(timeZone);
            this.selectedTimeZone = this.timeZones.find((tz) => tz.value === timeZone);
            $rootScope.$broadcast('BBTimeZoneOptions:timeZoneChanged', timeZone);
            if (!isAutomaticTimeZone) bbTimeZone.setLocalStorage({displayTimeZone: timeZone});
        };

        const languageChangedHandler = () => {
            this.$onInit();
        };

        $scope.$on('BBLanguagePicker:languageChanged', languageChangedHandler);

    }

})();
