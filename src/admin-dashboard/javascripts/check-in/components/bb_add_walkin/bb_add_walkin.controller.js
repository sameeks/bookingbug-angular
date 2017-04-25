(() => {

    angular
        .module('BBAdminDashboard.check-in.controllers')
        .controller('bbAddWalkinCtrl', bbAddWalkinCtrl);

    function bbAddWalkinCtrl($scope, AdminBookingPopup) {
        /***
         * @ngdoc method
         * @name walkIn
         * @methodOf BBAdminDashboard.check-in.directives:bbAddWalkin
         * @description
         * Intitialises modal to create a walk in appointment
         *
        */
        this.walkIn = () => {
            AdminBookingPopup.open({
                item_defaults: {
                    pick_first_time: true,
                    merge_people: true,
                    merge_resources: true,
                    date: moment().format('YYYY-MM-DD')
                },
                on_conflict: "cancel()",
                company_id: $scope.bb.company.id
            });
        };
    }

})();

