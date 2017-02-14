// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc controller
 * @name BBAdminDashboard.check-in.controllers.controller:CheckInPageCtrl
 *
 * @description
 * Controller for the check-in page
 */
angular.module('BBAdminDashboard.check-in.controllers')
    .controller('CheckInPageCtrl', ['$scope', '$state', '$log', function ($scope, $state, $log) {
        let pusher_channel = $scope.company.getPusherChannel('bookings');
        let refetch = _.throttle(function (data) {
                $log.info('== booking push received in checkin  == ', data);
                return $scope.$broadcast('refetchCheckin', data);
            }
            , 1000, {leading: false});

        if (pusher_channel) {
            pusher_channel.bind('create', refetch);
            pusher_channel.bind('update', refetch);
            return pusher_channel.bind('destroy', refetch);
        }
    }
    ]);
