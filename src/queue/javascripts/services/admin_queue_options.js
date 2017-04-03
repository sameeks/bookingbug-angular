/*
* @ngdoc service
* @name BBQueue.services.service:AdminQueueOptions
*
* @description
* Returns a set of admin queueing configuration options
*/

/*
* @ngdoc service
* @name BBQueue.services.service:AdminQueueOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminQueueOptionsProvider', (AdminQueueOptionsProvider) ->
    AdminQueueOptionsProvider.setOption('option', 'value')
  ]
  </example>
*/
angular.module('BBQueue.services').provider('AdminQueueOptions', function() {
    let options = {
        use_default_states: true,
        show_in_navigation: true,
        parent_state: 'root'
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

});
