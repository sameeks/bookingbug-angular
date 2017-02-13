/*
* @ngdoc service
* @name BBAdminDashboard.clients.services.service:AdminClientsOptions
*
* @description
* Returns a set of admin calendar configuration options
*/

/*
* @ngdoc service
* @name BBAdminDashboard.clients.services.service:AdminClientsOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminClientsOptionsProvider', (AdminClientsOptionsProvider) ->
    AdminClientsOptionsProvider.setOption('option', 'value')
  ]
  </example>
*/
angular.module('BBAdminDashboard.clients.services').provider('AdminClientsOptions', [ function() {
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