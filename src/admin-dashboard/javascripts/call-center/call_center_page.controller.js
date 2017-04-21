(function (angular) {

    angular
        .module('BBAdminDashboard.callCenter')
        .controller('CallCenterPageCtrl', CallCenterPageCtrl);

    function CallCenterPageCtrl() {
        'ngInject';

        let init = function () {
            console.info('works!!!');
        };

        init();
    }

})(angular);
