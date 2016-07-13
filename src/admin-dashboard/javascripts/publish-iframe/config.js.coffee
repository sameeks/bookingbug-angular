'use strict'

angular.module('BBAdminDashboard.publish-iframe.controllers', [])
angular.module('BBAdminDashboard.publish-iframe.services', [])
angular.module('BBAdminDashboard.publish-iframe.directives', [])
angular.module('BBAdminDashboard.publish-iframe.translations', [])

angular.module('BBAdminDashboard.publish-iframe', [
  'BBAdminDashboard.publish-iframe.controllers',
  'BBAdminDashboard.publish-iframe.services',
  'BBAdminDashboard.publish-iframe.directives',
  'BBAdminDashboard.publish-iframe.translations'
])
.run ['RuntimeStates', 'AdminPublishIframeOptions', (RuntimeStates, AdminPublishIframeOptions) ->
  # Choose to opt out of the default routing
  if AdminPublishIframeOptions.use_default_states

    RuntimeStates
      .state 'publish',
        parent: AdminPublishIframeOptions.parent_state
        url: '/publish'
        templateUrl: 'admin_publish_page.html'
        controller: 'PublishIframePageCtrl'

      .state 'publish.page',
        url: '/page/:path'
        templateUrl: 'iframe_page.html'
        controller: 'PublishSubIframePageCtrl'
]
