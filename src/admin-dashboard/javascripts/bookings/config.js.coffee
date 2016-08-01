'use strict'

angular.module('BBAdminDashboard.bookings.controllers', [])
angular.module('BBAdminDashboard.bookings.services', [])
angular.module('BBAdminDashboard.bookings.directives', [])
angular.module('BBAdminDashboard.bookings.translations', [])

angular.module('BBAdminDashboard.bookings', [
  'BBAdminDashboard.bookings.controllers',
  'BBAdminDashboard.bookings.services',
  'BBAdminDashboard.bookings.directives',
  'BBAdminDashboard.bookings.translations'
])
.run ['RuntimeStates', 'AdminBookingsOptions', 'SideNavigationPartials', (RuntimeStates, AdminBookingsOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  console.log "loadd3"
  if AdminBookingsOptions.use_default_states

    RuntimeStates
      .state 'bookings',
        parent: AdminBookingsOptions.parent_state
        url: "bookings"
        templateUrl: "bookings/index.html"
        controller: 'BookingsPageCtrl'

      .state 'bookings.all',
        url: "/all"
        templateUrl: "bookings/listing.html"
        controller: 'BookingsAllPageCtrl'

      .state 'bookings.edit',
        url: "/edit/:id"
        templateUrl: "bookings/item.html"
        resolve:
          booking: (company, $stateParams, AdminBookingService) ->
            params =
              company_id: company.id
              id: $stateParams.id
            AdminBookingService.query(params)
        controller: 'BookingsEditPageCtrl'

  if AdminBookingsOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('bookings', 'bookings/nav.html')
]