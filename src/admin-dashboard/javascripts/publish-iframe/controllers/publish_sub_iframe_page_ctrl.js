// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc controller
 * @name BBAdminDashboard.publish-iframe.controllers.controller:PublishSubIframePageCtrl
 *
 * @description
 * Controller for the publish sub page
 */
angular.module('BBAdminDashboard.publish-iframe.controllers')
    .controller('PublishSubIframePageCtrl', ['$scope', '$state', '$stateParams', function ($scope, $state, $stateParams) {
        $scope.path = $stateParams.path;

        $scope.loading = true;
        return $scope.$on('iframeLoaded', function () {
            $scope.loading = false;
            return $scope.$apply();
        });
    }
    ]);
