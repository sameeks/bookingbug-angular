// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc service
* @name BBAdminDashboard.check-in.services.service:AdminCheckInOptions
*
* @description
* Returns a set of admin calendar configuration options
*/

/*
* @ngdoc service
* @name BBAdminDashboard.check-in.services.service:AdminCheckInOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminCheckInOptionsProvider', (AdminCheckInOptionsProvider) ->
    AdminCheckInOptionsProvider.setOption('option', 'value')
  ]
  </example>
*/
angular.module('BBAdminDashboard.check-in.services').provider('AdminCheckInOptions', [ function() {
  // This list of options is meant to grow
  let options = {
    use_default_states : true,
    show_in_navigation : true,
    parent_state       : 'root'
  };

  this.setOption = function(option, value) {
    if (options.hasOwnProperty(option)) {
      options[option] = value;
    }
  };

  this.getOption = function(option) {
    if (options.hasOwnProperty(option)) {
      return options[option];
    }
  };
  this.$get =  () => options;

}
]);