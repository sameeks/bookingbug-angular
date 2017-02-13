// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc service
* @module BB.Services
* @name AdminBookingOptions
*
* @description
* Returns a set of Admin Booking configuration options
*/

/*
* @ngdoc service
* @module BB.Services
* @name AdminBookingOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminBookingOptionsProvider', (AdminBookingOptionsProvider) ->
    GeneralOptionsProvider.setOption('twelve_hour_format', true)
  ]
  </example>
*/
angular.module('BB.Services').provider('AdminBookingOptions', function() {
  // This list of default options is meant to grow
  let options = {
    merge_resources: true,
    merge_people: true,
    day_view: 'multi_day',
    mobile_pattern: null,
    use_default_company_id: false
  };

  this.setOption = function(option, value) {
    if (options.hasOwnProperty(option)) {
      options[option] = value;
    }
  };

  this.$get =  () => options;

});

