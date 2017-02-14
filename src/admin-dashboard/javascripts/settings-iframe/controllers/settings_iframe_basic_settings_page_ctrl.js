// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc controller
 * @name BBAdminDashboard.settings-iframe.controllers.controller:SettingsIframeBasicSettingsPageCtrl
 *
 * @description
 * Controller for the settings page
 */
angular.module('BBAdminDashboard.settings-iframe.controllers')
    .controller('SettingsIframeBasicSettingsPageCtrl', ['$scope', '$state', '$rootScope', function ($scope, $state, $rootScope) {
        $scope.pageHeader = 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TITLE';

        $scope.tabs = [
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_BUSINESS',
                icon: 'fa fa-globe',
                path: 'settings.basic-settings.page({path: "conf/setting/user_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_SERVICES',
                icon: 'fa fa-wrench',
                path: 'settings.basic-settings.page({path: "conf/setting/service_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_EVENTS',
                icon: 'fa fa-ticket',
                path: 'settings.basic-settings.page({path: "conf/setting/session_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_RESOURCES',
                icon: 'fa fa-archive',
                path: 'settings.basic-settings.page({path: "conf/setting/resource_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_WIDGET',
                icon: 'fa fa-calendar-times-o',
                path: 'settings.basic-settings.page({path: "conf/setting/widget_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_BOOKINGS',
                icon: 'fa fa-book',
                path: 'settings.basic-settings.page({path: "conf/setting/booking_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_NOTIFICATIONS',
                icon: 'fa fa-envelope',
                path: 'settings.basic-settings.page({path: "conf/setting/notifier_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_PRICING',
                icon: 'fa fa-credit-card',
                path: 'settings.basic-settings.page({path: "conf/setting/pricing_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_TERMINOLOGY',
                icon: 'fa fa-language',
                path: 'settings.basic-settings.page({path: "conf/language/user_edit"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_CUSTOM_TCS',
                icon: 'fa fa-pencil-square-o',
                path: 'settings.basic-settings.page({path: "conf/text/terms_conditions"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.BASIC_SETTINGS.TAB_EXTRA_FEATURES',
                icon: 'fa fa-trophy',
                path: 'settings.basic-settings.page({path: "conf/setting/features_edit"})'
            }
        ];

        $scope.contentsLoading = false;

        $scope.$on('iframeLoaded', function () {
            $scope.contentsLoading = false;
            return $scope.$apply();
        });

        return $scope.$on('iframeLoading', () => $scope.contentsLoading = true);
    }
    ]);
