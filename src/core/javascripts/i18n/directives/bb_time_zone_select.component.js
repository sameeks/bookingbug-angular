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
     *   <bb-time-zone-select></bb-time-zone-select>
     *   <bb-time-zone-select format="'(GMT offset-hours) location (tz-code)'"
     * </example>
     */

    angular
        .module('BB.i18n')
        .component('bbTimeZoneSelect', {
            templateUrl: 'i18n/_bb_timezone_select.html',
            bindings: {
                hideToggle: '<',
                format: '<'
            },
            controller: TimeZoneSelectCtrl,
            controllerAs: '$bbTimeZoneSelectCtrl'
        });

    function TimeZoneSelectCtrl($rootScope, $scope, $localStorage, bbi18nOptions, bbTimeZone, bbTimeZoneOptions) {
        'ngInject';

        this.timeZones = [];
        this.useMomentNames = false;
        this.isAutomaticTimeZone = false;
        this.selectedTimeZone = null;

        this.$onInit = () => {
            this.useMomentNames = bbi18nOptions.timeZone.useMomentNames;
            this.timeZones = bbTimeZoneOptions.composeTimeZoneList(this.format);
            this.setTimeZone = setTimeZone;
            this.automaticTimeZoneToggle = automaticTimeZoneToggle;
            $rootScope.connection_started ? $rootScope.connection_started.then(determineDefaults) : determineDefaults();
        };

        const determineDefaults = () => {
            const localStorage = $localStorage.getObject('bbTimeZone');
            const displayTimeZone = bbTimeZone.getTimeZoneKey(bbTimeZone.getDisplayTimeZone(), this.useMomentNames);
            this.isAutomaticTimeZone = (localStorage.useBrowserTimeZone || (bbi18nOptions.timeZone.useBrowser && !localStorage.displayTimeZone));
            this.selectedTimeZone = this.timeZones.find((tz) => tz.value === displayTimeZone);
        };

        const automaticTimeZoneToggle = () => {
            const timeZoneKey = this.isAutomaticTimeZone ? moment.tz.guess() : bbTimeZone.getCompanyTimeZone();
            const timeZone = bbTimeZone.getTimeZoneKey(timeZoneKey, this.useMomentNames);
            this.timeZones = bbTimeZoneOptions.addMissingTimeZones(this.timeZones, this.format);
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
