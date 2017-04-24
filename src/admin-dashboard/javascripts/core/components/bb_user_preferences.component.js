(function () {

    'use strict';

    /*
     * @ngdoc component
     * @name BBAdminDashboard.userPreferences
     *
     * @description
     * Preferences component in Admin user dropdown
     *
     * @example
     * <example>
     *   <user-preferences></user-preferences>
     * </example>
     */

    angular
        .module('BBAdminDashboard')
        .component('bbUserPreferences', {
            templateUrl: 'core/_bb_user_preferences.html',
            controller: UserPreferencesCtrl,
            controllerAs: '$bbUserPreferencesCtrl'
        });

    function UserPreferencesCtrl() {
        this.preventClose = (event) => event.stopPropagation();
    }

})();
