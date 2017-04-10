angular
    .module('BBAdminDashboard.check-in.directives')
    .controller('bbAddWalkinCtrl', bbAddWalkinCtrl);

function bbAddWalkinCtrl($scope, AdminBookingPopup, $timeout) {
    $scope.walkIn = () => {
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
    }
}
