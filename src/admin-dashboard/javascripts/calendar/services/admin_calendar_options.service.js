/*
 * @ngdoc service
 * @name BBAdminDashboard.calendar.services.service:AdminCalendarOptions
 *
 * @description
 * Returns a set of admin calendar configuration options
 */

/*
 * @ngdoc service
 * @name BBAdminDashboard.calendar.services.service:AdminCalendarOptionsProvider
 *
 * @description
 * Provider
 *
 * @example
 <example>
 angular.module('ExampleModule').config ['AdminCalendarOptionsProvider', (AdminCalendarOptionsProvider) ->
 AdminCalendarOptionsProvider.setOption('option', 'value')
 ]
 </example>
 */
angular.module('BBAdminDashboard.calendar.services').provider('AdminCalendarOptions', [function () {
    // This list of options is meant to grow
    let options = {
        use_default_states: true,
        show_in_navigation: true,
        parent_state: 'root',
        column_format: null,
        bookings_label_assembler: '{service_name} - {client_name}',
        block_label_assembler: 'Blocked',
        external_label_assembler: '{title}',
        minTime: null,
        maxTime: null
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
