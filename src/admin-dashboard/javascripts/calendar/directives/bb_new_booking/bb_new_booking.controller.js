(() => {

    angular
        .module('BBAdminDashboard.calendar.directives')
        .controller('bbNewBookingCtrl', bbNewBookingCtrl);

    function bbNewBookingCtrl($scope, AdminBookingPopup, $uibModal, $timeout, $rootScope, AdminBookingOptions) {
        /***
         * @ngdoc method
         * @name newBooking
         * @methodOf BBAdminDashboard.calendar.directives:bbNewBooking
         * @description
         * Open admin booking modal to create new appointment booking
         */
        $scope.newBooking = () => {
            AdminBookingPopup.open({
                item_defaults: {
                    day_view: AdminBookingOptions.day_view,
                    merge_people: true,
                    merge_resources: true,
                    date: moment($scope.$parent.currentDate).isValid() ? moment($scope.$parent.currentDate).format('YYYY-MM-DD') : moment().format('YYYY-MM-DD')
                },
                company_id: $rootScope.bb.company.id,
                on_conflict: "cancel()",
                template: 'main'
            });
        };
    }

})();


