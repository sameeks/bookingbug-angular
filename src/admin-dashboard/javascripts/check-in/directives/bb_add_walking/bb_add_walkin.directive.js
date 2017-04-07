angular
    .module('BBAdminDashboard.check-in.directives')
    .directive('bbAddWalking', bbAddWalking);

function bbAddWalkin() {
    let directive = {
        restrict: 'AE',
        replace: true,
        scope: true,
        controller: 'bbAddWalkingCtrl'
    }
}
