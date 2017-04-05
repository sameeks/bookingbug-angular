angular.module('BBAdminDashboard.check-in').run(function ($rootScope, RuntimeStates, AdminCheckInOptions, SideNavigationPartials) {
    'ngInject';

    // Choose to opt out of the default routing
    if (AdminCheckInOptions.use_default_states) {

        RuntimeStates
            .state('checkin', {
                    parent: AdminCheckInOptions.parent_state,
                    url: "check-in",
                    templateUrl: "check-in/index.html",
                    controller: 'CheckInPageCtrl'
                }
            );
    }

    $rootScope.$watch ('bb.company', (company) => {

        if (company) {
           company.$getServices().then((services) => {

               // Admin API /services endpoint includes 'event groups' in response as well as services.
               // Only display Check In menuitem if a service which is not an event group exists in company.
               if (AdminCheckInOptions.show_in_navigation) {
                   for (let service of services) {
                       if (!service.is_event_group) {
                           SideNavigationPartials.addPartialTemplate('check-in', 'check-in/nav.html');
                           return;
                       }
                   }
               }

           })
       }

    });

});
