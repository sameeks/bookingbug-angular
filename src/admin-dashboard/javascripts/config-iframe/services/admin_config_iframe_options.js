/*
 * @ngdoc service
 * @name BBAdminDashboard.config-iframe.services.service:AdminConfigIframeOptions
 *
 * @description
 * Returns a set of admin calendar configuration options
 */

/*
 * @ngdoc service
 * @name BBAdminDashboard.config-iframe.services.service:AdminConfigIframeOptionsProvider
 *
 * @description
 * Provider
 *
 * @example
 <example>
 angular.module('ExampleModule').config ['AdminConfigIframeOptionsProvider', (AdminConfigIframeOptionsProvider) ->
 AdminConfigIframeOptionsProvider.setOption('option', 'value')
 ]
 </example>
 */
angular.module('BBAdminDashboard.config-iframe.services').provider('AdminConfigIframeOptions', [function () {
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
