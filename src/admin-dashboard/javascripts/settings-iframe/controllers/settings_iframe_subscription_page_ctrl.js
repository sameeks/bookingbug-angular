// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc controller
 * @name BBAdminDashboard.settings-iframe.controllers.controller:SettingsIframeSubscriptionPageCtrl
 *
 * @description
 * Controller for the settings page
 */
angular.module('BBAdminDashboard.settings-iframe.controllers')
    .controller('SettingsIframeSubscriptionPageCtrl', ['$scope', '$state', '$rootScope', function ($scope, $state, $rootScope) {
        $scope.pageHeader = 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.SUBSCRIPTION.TITLE';

        $scope.tabs = [
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.SUBSCRIPTION.TAB_STATUS',
                icon: null,
                path: 'settings.subscription.page({path: "subscription/show"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.SUBSCRIPTION.TAB_PAYMENT_HISTORY',
                icon: null,
                path: 'settings.subscription.page({path: "payment_event"})'
            },
            {
                name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.SUBSCRIPTION.TAB_INVOICES',
                icon: null,
                path: 'settings.subscription.page({path: "payment_invoice"})'
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
