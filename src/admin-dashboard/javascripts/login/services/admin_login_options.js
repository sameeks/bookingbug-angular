(function (angular) {

    /*
     * @ngdoc service
     * @name BBAdminDashboard.login.services.service:AdminLoginOptions
     *
     * @description
     * Returns a set of admin calendar configuration options
     */

    /*
     * @ngdoc service
     * @name BBAdminDashboard.login.services.service:AdminLoginOptionsProvider
     *
     * @description
     * Provider
     *
     * @example
     <example>
     angular.module('ExampleModule').config ['AdminLoginOptionsProvider', (AdminLoginOptionsProvider) ->
     AdminLoginOptionsProvider.setOption('option', 'value')
     ]
     </example>
     */
    angular.module('BBAdminDashboard.login.services').provider('AdminLoginOptions', AdminLoginOptions);

    function AdminLoginOptions() {
        'ngInject';

        let options = {
            show_api_field: false,
            use_default_states: true,
            show_in_navigation: true,
            parent_state: 'root',
            sso_token: null,
            company_id: null

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

})(angular);
