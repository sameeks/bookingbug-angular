angular.module('BBQueue').run(function(RuntimeStates, AdminQueueOptions, SideNavigationPartials) {
    if (AdminQueueOptions.use_default_states) {
        RuntimeStates
            .state('queue', {
                parent: AdminQueueOptions.parent_state,
                url: "queue",
                resolve: {
                    company(user) {
                        return user.$getCompany();
                    },
                    services(company) {
                        return company.$getServices();
                    },
                    resources(company) {
                        return [];
                    },
                    people(company) {
                        return company.$getPeople();
                    },
                    addresses(company, AdminAddressService) {
                        return [];
                    }
                },
                controller($scope, services, resources, people) {
                    $scope.services = services;
                    $scope.people = people;
                    return $scope.resources = resources;
                },
                templateUrl: "queue/index.html"
            }).state('queue.concierge', {
                parent: 'queue',
                url: "/concierge",
                templateUrl: "queue/concierge.html",
                controller: 'QueueConciergePageCtrl'
            }).state('queue.server', {
                parent: 'queue',
                url: "/server/:id",
                resolve: {
                    person(people, $stateParams) {
                        return _.findWhere(people, {
                            id: parseInt($stateParams.id),
                            queuing_disabled: false
                        });
                    }
                },
                templateUrl: "queue/server.html",
                controller($scope, $stateParams, person) {
                    $scope.person = person;
                }
            }
        );
    }


    if (AdminQueueOptions.show_in_navigation) {
        SideNavigationPartials.addPartialTemplate('queue', 'queue/nav.html');
    }
});


angular.module('BBQueue').run(function($injector, BBModel, $translate) {
    let models = ['Queuer', 'ClientQueue'];

    for (let model of Array.from(models)) {
        BBModel['Admin'][model] = $injector.get(`Admin${model}Model`);
    }
});


angular.module('BBQueue').run(function(AdminCoreOptions, SideNavigationPartials) {
    let side_nav = AdminCoreOptions.side_navigation;
    side_nav.unshift({
        group_name: 'SIDE_NAV_QUEUING',
        items: [
            'queue'
        ]
    });
    let booking_items = _.findWhere(side_nav, {group_name: 'SIDE_NAV_BOOKINGS'}).items;
    let check_in_index = booking_items.indexOf('check-in');
    booking_items.splice(check_in_index, 1);
    SideNavigationPartials.removePartialTemplate('check-in');
    AdminCoreOptions.side_navigation = side_nav;
});
