/*
* @ngdoc service
* @name BBAdminDashboard.settings-iframe.services.service:AdminSettingsIframeOptions
*
* @description
* Returns a set of General configuration options
*/

/*
* @ngdoc service
* @name BBAdminDashboard.settings-iframe.services.service:AdminSettingsIframeOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminSettingsIframeOptionsProvider', (AdminSettingsIframeOptionsProvider) ->
    AdminSettingsIframeOptionsProvider.setOption('option', 'value')
  ]
  </example>
*/
angular.module('BBAdminDashboard.settings-iframe.services').provider('AdminSettingsIframeOptions', [ function() {
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