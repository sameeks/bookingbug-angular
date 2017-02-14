// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc directive
 * @name BBAdminDashboard.directive:bbClassicSwitch
 * @scope
 * @restrict A
 *
 * @description
 * Create a link that switches back to BB Classic mode
 *
 */
angular.module('BBAdminDashboard').directive('bbClassicSwitch', [() =>
    ({
        restrict: 'A',
        scope: false,
        link(scope, element, attrs) {
            if (scope.bb.api_url) {
                return attrs.$set('href', scope.bb.api_url + "?dashboard_redirect=true");
            }
        }
    })

]);
