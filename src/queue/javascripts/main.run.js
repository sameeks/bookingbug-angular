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
                    },
                    bookings(company, BBModel) {
                        let params = {
                            company,
                            start_date: moment().format('YYYY-MM-DD'),
                            end_date: moment().format('YYYY-MM-DD'),
                            start_time: moment().format('HH:mm'),
                            skip_cache: false
                        }
                        return BBModel.Admin.Booking.$query(params)
                    }
                },
                controller($scope, services, resources, people, bookings) {
                    $scope.bookings = bookings;
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
