/**
 * @ngdoc service
 * @name BBAdminDashboard.AdminCoreOptions
 *
 * @description
 * Returns a set of General configuration options
 */

/**
 * @ngdoc service
 * @name BBAdminDashboard.AdminCoreOptionsProvider
 *
 * @description
 *
 * @example
 <pre>

 config = (AdminCoreOptionsProvider) ->
 'ngInject'

 AdminCoreOptionsProvider.setOption('option', 'value')

 return

 angular.module('ExampleModule').config config
 </pre>
 */

angular.module('BBAdminDashboard').provider('AdminCoreOptions', function () {
    'ngInject';

    let options = {
        default_state: 'calendar',
        deactivate_sidenav: false,
        deactivate_boxed_layout: false,
        sidenav_start_open: true,
        boxed_layout_start: false,
        side_navigation: [
            {
                group_name: 'SIDE_NAV_BOOKINGS',
                items: [
                    'calendar',
                    'clients',
                    'check-in',
                    'dashboard-iframe',
                    'members-iframe',
                ]
            },
            {
                group_name: 'SIDE_NAV_CONFIG',
                items: [
                    'config-iframe',
                    'publish-iframe',
                    'settings-iframe'
                ]
            }
        ]
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

});


