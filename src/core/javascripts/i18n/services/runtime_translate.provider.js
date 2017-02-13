// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
* @ngdoc service
* @name BB.i18n.RuntimeTranslate
*
* @description
* Returns an instance of $translateProvider that allows late language binding (on runtime)
*/

/**
* @ngdoc service
* @name BB.i18n.RuntimeTranslateProvider
*
* @description
* Provider
*
* @example
  <pre>
  angular.module('ExampleModule').config ['RuntimeTranslateProvider', '$translateProvider', (RuntimeTranslateProvider, $translateProvider) ->
    RuntimeTranslateProvider.setProvider($translateProvider)
  ]
  </pre>
*/
angular.module('BB.i18n').provider('RuntimeTranslate', function($translateProvider){
  'ngInject';

  let translateProvider = $translateProvider;
  this.setProvider = provider=> translateProvider = provider;
  this.$get = () => translateProvider;
});
