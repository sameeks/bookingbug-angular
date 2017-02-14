// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc controller
 * @name BBAdminDashboard.calendar.controllers.controller:CalendarPageCtrl
 *
 * @description
 * Controller for the calendar page
 */
angular.module('BBAdminDashboard.calendar.controllers')
    .controller('CalendarPageCtrl', function ($log, $scope, $state) {
        'ngInject';

        let init = function () {

            bindToPusherChannel();

            if ($state.current.name === 'calendar') {
                gotToProperState();
            }

        };

        var gotToProperState = function () {

            if ($scope.bb.company.$has('people')) {
                $state.go("calendar.people");
            } else if ($scope.bb.company.$has('resources')) {
                $state.go("calendar.resources");
            }

        };

        var bindToPusherChannel = function () {
            let pusherChannel = $scope.company.getPusherChannel('bookings');

            if (pusherChannel) {
                pusherChannel.bind('create', refetch);
                pusherChannel.bind('update', refetch);
                pusherChannel.bind('destroy', refetch);
            }

        };

        var refetch = _.throttle(function (data) {
                $log.info('== booking push received in bookings == ', data);
                return $scope.$broadcast('refetchBookings', data);
            }
            , 1000, {leading: false});

        init();

    });
