/*
 * @ngdoc service
 * @module BB.Services
 * @name GeneralOptions
 *
 * @description
 * Returns a set of General configuration options
 */

/*
 * @ngdoc service
 * @module BB.Services
 * @name GeneralOptionsProvider
 *
 * @description
 * Provider
 *
 * @example
 <example>
 angular.module('ExampleModule').config ['GeneralOptionsProvider', (GeneralOptionsProvider) ->
 GeneralOptionsProvider.setOption('twelve_hour_format', true)
 ]
 </example>
 */
angular.module('BB.Services').provider('GeneralOptions', function () {

    let options = {
        twelve_hour_format: false,
        calendar_minute_step: 5,
        calendar_min_time: "09:00",
        calendar_max_time: "18:00",
        set_time_zone_automatically: false,
        custom_time_zone: false,
        calendar_slot_duration: 5,
        use_local_time_zone: false,
        display_time_zone: null,
        update_document_title: false,
        scroll_offset: 0
    };


    this.setOption = function (option, value) {
        if (options.hasOwnProperty(option)) {
            options[option] = value;
        }
    };

    this.$get = () => options;

});
