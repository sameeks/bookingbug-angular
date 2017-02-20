angular.module('BBAdminDashboard.clients').run(function (RuntimeStates, AdminClientsOptions, SideNavigationPartials) {
    'ngInject';

    // Choose to opt out of the default routing
    if (AdminClientsOptions.use_default_states) {

        RuntimeStates
            .state('clients', {
                parent: AdminClientsOptions.parent_state,
                url: "clients",
                templateUrl: "clients/index.html",
                controller: 'ClientsPageCtrl'
            }).state('clients.new', {
            url: "/new",
            templateUrl: "client_new.html",
            controller: 'ClientsNewPageCtrl'
        }).state('clients.all', {
            url: "/all",
            templateUrl: "clients/listing.html",
            controller: 'ClientsAllPageCtrl'
        }).state('clients.edit', {
                url: "/edit/:id",
                templateUrl: "clients/item.html",
                resolve: {
                    client(company, $stateParams, BBModel) {
                        let params = {
                            company,
                            id: $stateParams.id
                        };
                        return BBModel.Admin.Client.$query(params);
                    }
                },
                controller: 'ClientsEditPageCtrl'
            }
        );
    }

    if (AdminClientsOptions.show_in_navigation) {
        SideNavigationPartials.addPartialTemplate('clients', 'clients/nav.html');
    }

});
