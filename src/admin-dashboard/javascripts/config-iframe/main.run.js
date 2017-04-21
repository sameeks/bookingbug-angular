(function (angular) {

    angular.module('BBAdminDashboard.config-iframe').run(configIframeRun);

    function configIframeRun(RuntimeStates, AdminConfigIframeOptions, SideNavigationPartials) {
        'ngInject';

        if (AdminConfigIframeOptions.use_default_states) {

            RuntimeStates
                .state('config', {
                    parent: AdminConfigIframeOptions.parent_state,
                    url: 'config',
                    templateUrl: 'config-iframe/index.html',
                    controller: 'ConfigIframePageCtrl',
                    deepStateRedirect: {
                        default: {
                            state: 'config.business.page',
                            params: {
                                path: 'person'
                            }
                        }
                    }
                })
                .state('config.business', {
                    url: '/business',
                    templateUrl: 'core/tabbed-substates-page.html',
                    controller: 'ConfigIframeBusinessPageCtrl',
                    deepStateRedirect: {
                        default: {
                            state: 'config.business.page',
                            params: {
                                path: 'person'
                            }
                        }
                    }
                })
                .state('config.business.page', {
                    url: '/page/:path',
                    templateUrl: 'core/iframe-page.html',
                    controller: 'ConfigSubIframePageCtrl'
                })
                .state('config.event-settings', {
                    url: '/event-settings',
                    templateUrl: 'core/tabbed-substates-page.html',
                    controller: 'ConfigIframeEventSettingsPageCtrl',
                    deepStateRedirect: {
                        default: {
                            state: 'config.event-settings.page',
                            params: {
                                path: 'sessions/courses'
                            }
                        }
                    }
                })
                .state('config.event-settings.page', {
                    url: '/page/:path',
                    templateUrl: 'core/iframe-page.html',
                    controller: 'ConfigSubIframePageCtrl'
                })
                .state('config.promotions', {
                    url: '/promotions',
                    templateUrl: 'core/tabbed-substates-page.html',
                    controller: 'ConfigIframePromotionsPageCtrl',
                    deepStateRedirect: {
                        default: {
                            state: 'config.promotions.page',
                            params: {
                                path: 'price/deal/summary'
                            }
                        }
                    }
                })
                .state('config.promotions.page', {
                    url: '/page/:path',
                    templateUrl: 'core/iframe-page.html',
                    controller: 'ConfigSubIframePageCtrl'
                })
                .state('config.booking-settings', {
                    url: '/booking-settings',
                    templateUrl: 'core/tabbed-substates-page.html',
                    controller: 'ConfigIframeBookingSettingsPageCtrl',
                    deepStateRedirect: {
                        default: {
                            state: 'config.booking-settings.page',
                            params: {
                                path: 'detail_type'
                            }
                        }
                    }
                })
                .state('config.booking-settings.page', {
                    url: '/page/:path',
                    templateUrl: 'core/iframe-page.html',
                    controller: 'ConfigSubIframePageCtrl'
                });
        }

        if (AdminConfigIframeOptions.show_in_navigation) {
            SideNavigationPartials.addPartialTemplate('config-iframe', 'config-iframe/nav.html');
        }
    }
})(angular);
