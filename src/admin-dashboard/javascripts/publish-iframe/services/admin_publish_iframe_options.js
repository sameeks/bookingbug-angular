/*
* @ngdoc service
* @name BBAdminDashboard.publish-iframe.services.service:AdminPublishIframeOptions
*
* @description
* Returns a set of General configuration options
*/

/*
* @ngdoc service
* @name BBAdminDashboard.publish-iframe.services.service:AdminPublishIframeOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminPublishIframeOptionsProvider', (AdminPublishIframeOptionsProvider) ->
    AdminPublishIframeOptionsProvider.setOption('option', 'value')
  ]
  </example>
*/
angular.module('BBAdminDashboard.publish-iframe.services').provider('AdminPublishIframeOptions', [ function() {
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