'use strict'

angular.module('BBAdminDashboard.clients.controllers', [])
angular.module('BBAdminDashboard.clients.services', [])
angular.module('BBAdminDashboard.clients.directives', [])
angular.module('BBAdminDashboard.clients.translations', [])

angular.module('BBAdminDashboard.clients', [
  'BBAdminDashboard.clients.controllers',
  'BBAdminDashboard.clients.services',
  'BBAdminDashboard.clients.directives',
  'BBAdminDashboard.clients.translations'
])
.run ['RuntimeStates', 'AdminClientsOptions', 'SideNavigationPartials', (RuntimeStates, AdminClientsOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  if AdminClientsOptions.use_default_states

    RuntimeStates
      .state 'clients',
        parent: AdminClientsOptions.parent_state
        url: "/clients"
        templateUrl: "clients/index.html"
        controller: 'ClientsPageCtrl'

      .state 'clients.new',
        url: "/new"
        templateUrl: "client_new.html"
        controller: 'ClientsNewPageCtrl'

      .state 'clients.all',
        url: "/all"
        templateUrl: "clients/listing.html"
        controller: 'ClientsAllPageCtrl'

      .state 'clients.edit',
        url: "/edit/:id"
        templateUrl: "clients/item.html"
        resolve:
          client: (company, $stateParams, AdminClientService) ->
            params =
              company_id: company.id
              id: $stateParams.id
            AdminClientService.query(params)
        controller: 'ClientsEditPageCtrl'

  if AdminClientsOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('clients', 'clients/nav.html')
]