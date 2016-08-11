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
.run ['RuntimeStates', 'AdminClientsOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminClientsOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminClientsOptions.use_default_states

    RuntimeStates
      .state 'clients',
        parent: AdminClientsOptions.parent_state
        url: "clients"
        templateUrl: 'clients/index.html'
        controller: 'ClientsPageCtrl'
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.environment == 'development'
              script = 'bb-angular-admin-dashboard-clients.lazy.js'
            else
              script = 'bb-angular-admin-dashboard-clients.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }

      .state 'clients.all',
        url: "/all"
        templateUrl: 'clients/listing.html'
        controller: 'ClientsAllPageCtrl'

      .state 'clients.edit',
        url: "/edit/:id"
        template: ()->
          $templateCache.get('clients/item.html')
        resolve:
          client: (company, $stateParams, AdminClientService) ->
            params =
              company_id: company.id
              id: $stateParams.id
            AdminClientService.query(params)

        controller: 'ClientsEditPageCtrl'

  if AdminClientsOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('clients', 'core/nav/clients.html')
]