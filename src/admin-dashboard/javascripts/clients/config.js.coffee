'use strict'

angular.module('BBAdminDashboard.clients.controllers', [])
angular.module('BBAdminDashboard.clients.services', [])
angular.module('BBAdminDashboard.clients.directives', [])

angular.module('BBAdminDashboard.clients', [
  'BBAdminDashboard.clients.controllers',
  'BBAdminDashboard.clients.services',
  'BBAdminDashboard.clients.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'clients',
      parent: 'root'
      url: "/clients"
      templateUrl: "admin_clients.html"
      controller: 'ClientsPageCtrl'
       
    .state 'clients.new',
      url: "/new"
      templateUrl: "client_new.html"
      controller: 'ClientsNewPageCtrl'

    .state 'clients.all',
      url: "/all"
      templateUrl: "all_clients.html"
      controller: 'ClientsAllPageCtrl'

    .state 'clients.edit',
      url: "/edit/:id"
      templateUrl: "admin_client.html"
      resolve:
        client: (company, $stateParams, AdminClientService) ->
          params =
            company_id: company.id
            id: $stateParams.id
          AdminClientService.query(params)
      controller: 'ClientsEditPageCtrl'
]