// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.publish-iframe').run(function (RuntimeStates, AdminPublishIframeOptions, SideNavigationPartials) {
    'ngInject';

// Choose to opt out of the default routing
    if (AdminPublishIframeOptions.use_default_states) {

        RuntimeStates
            .state('publish', {
                parent: AdminPublishIframeOptions.parent_state,
                url: 'publish',
                templateUrl: 'publish-iframe/index.html',
                controller: 'PublishIframePageCtrl',
                deepStateRedirect: {
                    default: {
                        state: 'publish.page',
                        params: {
                            path: 'conf/inset/intro'
                        }
                    }
                }
            })

            .state('publish.page', {
                    url: '/page/:path',
                    templateUrl: 'core/boxed-iframe-page.html',
                    controller: 'PublishSubIframePageCtrl'
                }
            );
    }

    if (AdminPublishIframeOptions.show_in_navigation) {
        SideNavigationPartials.addPartialTemplate('publish-iframe', 'publish-iframe/nav.html');
    }

});
