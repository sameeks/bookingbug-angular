/*
 * @ngdoc service
 * @name BBAdminDashboard.dashboard-iframe.services.service:AdminDashboardIframeOptions
 *
 * @description
 * Returns a set of admin calendar configuration options
 */

/*
 * @ngdoc service
 * @name BBAdminDashboard.dashboard-iframe.services.service:AdminDashboardIframeOptionsProvider
 *
 * @description
 * Provider
 *
 * @example
 <example>
 angular.module('ExampleModule').config ['AdminDashboardIframeOptionsProvider', (AdminDashboardIframeOptionsProvider) ->
 AdminDashboardIframeOptionsProvider.setOption('option', 'value')
 ]
 </example>
 */
angular.module('BBAdminDashboard.dashboard-iframe.services').provider('AdminDashboardIframeOptions', [function () {
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
