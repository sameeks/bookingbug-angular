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

    function TimeZoneSelectCtrl($rootScope, $scope, $localStorage, bbi18nOptions, bbTimeZone, bbTimeZoneOptions, bbTimeZoneUtils) {
        'ngInject';

        const LIST_CAPACITY = 100;
        let companyTimeZone;
        let displayTimeZone;
        let browserTimeZone;

        this.timeZones = [];
        this.isAutomaticTimeZone = false;
        this.selectedTimeZone = null;
        this.isLongList = false;

        this.$onInit = () => {
            this.timeZones = bbTimeZoneOptions.composeTimeZoneList(this.format, bbTimeZone.getDisplay());
            this.isLongList = this.timeZones.length > LIST_CAPACITY;
            this.setTimeZone = setTimeZone;
            this.automaticTimeZoneToggle = automaticTimeZoneToggle;
            $rootScope.connection_started ? $rootScope.connection_started.then(determineDefaults) : determineDefaults();
        };

        const determineDefaults = () => {
            const localStorage = $localStorage.getObject('bbTimeZone');
            const getEqualTzInList = (timeZone) => bbTimeZoneUtils.getEqualInList(timeZone, this.timeZones);
            companyTimeZone = getEqualTzInList(bbTimeZone.getCompany());
            displayTimeZone = getEqualTzInList(bbTimeZone.getDisplay());
            browserTimeZone = getEqualTzInList(moment.tz.guess());
            this.isAutomaticTimeZone = (localStorage.useBrowserTimeZone || (bbi18nOptions.timeZone.useBrowser && !localStorage.displayTimeZone));
            this.selectedTimeZone = this.timeZones.find((tz) => tz.value === displayTimeZone);
        };

        const automaticTimeZoneToggle = () => {
            displayTimeZone = this.isAutomaticTimeZone ? browserTimeZone : companyTimeZone;
            this.timeZones = bbTimeZoneOptions.addMissingTimeZones(this.timeZones, this.format, displayTimeZone);
            setTimeZone(displayTimeZone, this.isAutomaticTimeZone);
            $scope.$broadcast('UISelect:closeSelect');
            bbTimeZone.setLocalStorage({useBrowserTimeZone: this.isAutomaticTimeZone});
        };

        const setTimeZone = (timeZone, isAutomaticTimeZone = false) => {
            displayTimeZone = timeZone;
            bbTimeZone.setDisplay(timeZone);
            this.selectedTimeZone = this.timeZones.find((tz) => tz.value === timeZone);
            $rootScope.$broadcast('BBTimeZoneOptions:timeZoneChanged', timeZone);
            if (!isAutomaticTimeZone) bbTimeZone.setLocalStorage({displayTimeZone: timeZone});
        };

        const languageChangedHandler = () => {
            this.timeZones = bbTimeZoneOptions.composeTimeZoneList(this.format, displayTimeZone);
            this.selectedTimeZone = this.timeZones.find((tz) => tz.value === displayTimeZone);
        };

        $scope.$on('BBLanguagePicker:languageChanged', languageChangedHandler);

    }

})();
