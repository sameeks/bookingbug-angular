/***
 * @ngdoc component
 * @name BBAdminDashboard:bbAddWalkin
 * @description
 *
 * Intitialises modal to create a walk-in appointment
 */

(function () {

    angular
        .module('BBAdminDashboard')
        .component('bbAddWalkin', {
            templateUrl: 'check-in/walk-in.html',
            controller: bbAddWalkinCtrl,
            controllerAs: '$bbAddWalkinCtrl',
            bindings: {
                companyId: '='
            }
        });

    function bbAddWalkinCtrl($scope, AdminBookingPopup) {
        this.walkIn = () => {
            AdminBookingPopup.open({
                item_defaults: {
                    pick_first_time: true,
                    merge_people: true,
                    merge_resources: true,
                    date: moment().format('YYYY-MM-DD')
                },
                on_conflict: "cancel()",
                company_id: this.companyId
            });
        };
    }
})();
