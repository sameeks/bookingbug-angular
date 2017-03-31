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
                restrictRegion: '<',
                options: '<'
            },
            controller: TimeZoneOptionsCtrl,
            controllerAs: '$bbTimeZoneOptionsCtrl'
        });

    function TimeZoneOptionsCtrl($scope, $rootScope, bbTimeZone, bbTimeZoneOptions, CompanyStoreService, bbi18nOptions, $localStorage) {
        'ngInject';

        const ctrl = this;

        ctrl.timeZones = [];
        ctrl.isAutomaticTimeZone = false;
        ctrl.selectedTimeZone = null;

        ctrl.$onInit = function () {
            ctrl.timeZones = bbTimeZoneOptions.generateTimeZoneList(ctrl.restrictRegion, ctrl.options); //TODO should be more customisable
            ctrl.updateTimeZone = updateTimeZone;
            ctrl.automaticTimeZoneToggle = automaticTimeZoneToggle;
            if (bbi18nOptions.use_browser_time_zone && $localStorage.getItem('bbTimeZone') === undefined) ctrl.isAutomaticTimeZone = true;
            $rootScope.connection_started ? $rootScope.connection_started.then(determineTimeZone) : determineTimeZone();
        };

        function determineTimeZone() {
            bbTimeZone.determineTimeZone();
            ctrl.selectedTimeZone = bbTimeZoneOptions.mapTimeZoneItem(bbTimeZone.getDisplayTimeZone());
        }

        function automaticTimeZoneToggle() {
            updateTimeZone(ctrl.isAutomaticTimeZone ? moment.tz.guess() : CompanyStoreService.time_zone);
            $scope.$broadcast('UISelect:closeSelect');
        }

        function updateTimeZone(timeZone) {
            if (timeZone === undefined) timeZone = ctrl.selectedTimeZone.value;
            ctrl.selectedTimeZone = bbTimeZoneOptions.mapTimeZoneItem(timeZone);
            bbTimeZone.setDisplayTimeZone(timeZone, true);
            $rootScope.$broadcast('BBTimeZoneOptions:timeZoneChanged', timeZone);
        }

        $scope.$on('BBLanguagePicker:languageChanged', languageChangedHandler);

        function languageChangedHandler() {
            ctrl.$onInit();
        }

    }

})();
