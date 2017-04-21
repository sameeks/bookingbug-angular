(function (angular) {

    angular.module('BBAdminDashboard.callCenter').run(callCenterRun);

    function callCenterRun(RuntimeStates, adminCallCenterOptions, SideNavigationPartials) {
        'ngInject';

        function init() {
            setStates();
            setSideNav();
        }

        function setStates() {
            if (!adminCallCenterOptions.useDefaultStates) return;

            RuntimeStates
                .state('callCenter', {
                        parent: adminCallCenterOptions.parentState,
                        url: "call-center",
                        templateUrl: "call-center/index.html",
                        controller: 'CallCenterPageCtrl'
                    }
                );
        }

        function setSideNav() {
            if (!adminCallCenterOptions.showInNavigation) return;
            SideNavigationPartials.addPartialTemplate('call-center', 'call-center/nav.html');
        }

        init();
    }

})(angular);
