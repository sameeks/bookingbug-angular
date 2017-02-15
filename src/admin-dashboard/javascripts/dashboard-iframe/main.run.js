angular.module('BBAdminDashboard.dashboard-iframe').run(function (RuntimeStates, AdminDashboardIframeOptions, SideNavigationPartials) {
    'ngInject';

    // Choose to opt out of the default routing
    if (AdminDashboardIframeOptions.use_default_states) {

        RuntimeStates
            .state('dashboard', {
                parent: AdminDashboardIframeOptions.parent_state,
                url: "dashboard",
                controller: "DashboardIframePageCtrl",
                templateUrl: "dashboard-iframe/index.html",
                deepStateRedirect: {
                    default: {
                        state: 'dashboard.page',
                        params: {
                            path: 'view/dashboard/index',
                            fixed: true
                        }
                    }
                }
            })

            .state('dashboard.page', {
                    url: "/page/:path",
                    controller: 'DashboardSubIframePageCtrl',
                    templateUrl: "core/iframe-page.html"
                }
            );
    }

    if (AdminDashboardIframeOptions.show_in_navigation) {
        SideNavigationPartials.addPartialTemplate('dashboard-iframe', 'dashboard-iframe/nav.html');
    }

});
