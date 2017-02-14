// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc service
 * @name BBAdminDashboard.members-iframe.services.service:AdminMembersIframeOptions
 *
 * @description
 * Returns a set of General configuration options
 */

/*
 * @ngdoc service
 * @name BBAdminDashboard.members-iframe.services.service:AdminMembersIframeOptionsProvider
 *
 * @description
 * Provider
 *
 * @example
 <example>
 angular.module('ExampleModule').config ['AdminMembersIframeOptionsProvider', (AdminMembersIframeOptionsProvider) ->
 AdminMembersIframeOptionsProvider.setOption('option', 'value')
 ]
 </example>
 */
angular.module('BBAdminDashboard.members-iframe.services').provider('AdminMembersIframeOptions', [function () {
    // This list of options is meant to grow
    let options = {
        use_default_states: true,
        show_in_navigation: true,
        parent_state: 'root'
    };

    this.setOption = function (option, value) {
        if (options.hasOwnProperty(option)) {
            options[option] = value;
        }
    };

    this.getOption = function (option) {
        if (options.hasOwnProperty(option)) {
            return options[option];
        }
    };
    this.$get = () => options;

}
]);
