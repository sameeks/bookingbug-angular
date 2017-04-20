(function (angular) {

    angular.module('BBAdminDashboard.callCenter').run(
        function (RuntimeStates, adminCallCenterOptions, SideNavigationPartials) {
            'ngInject';

            if (adminCallCenterOptions.useDefaultStates) {

                RuntimeStates
                    .state('callCenter', {
                            parent: adminCallCenterOptions.parentState,
                            url: "call-center",
                            templateUrl: "call-center/index.html",
                            controller: 'CallCenterPageCtrl'
                        }
                    );
            }

            if (adminCallCenterOptions.showInNavigation) {
                SideNavigationPartials.addPartialTemplate('call-center', 'call-center/nav.html');
            }

        }
    );

})(angular);
