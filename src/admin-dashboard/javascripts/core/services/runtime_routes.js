// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/**
 * @ngdoc service
 * @name BBAdminDashboard.RuntimeRoutes
 *
 * @description
 * Returns an instance of $routeProvider that allows late route binding (on runtime)
 */

/**
 * @ngdoc service
 * @name BBAdminDashboard.RuntimeRoutesProvider
 *
 * @description
 * Provider
 *
 * @example
 <pre>
 angular.module('ExampleModule').config ['RuntimeRoutesProvider', '$routeProvider', (RuntimeRoutesProvider, $routeProvider) ->
 RuntimeRoutesProvider.setProvider($routeProvider)
 ]
 </pre>
 */
angular.module('BBAdminDashboard').provider('RuntimeRoutes', ['$urlRouterProvider', function ($urlRouterProvider) {
    let routeProvider = $urlRouterProvider;
    this.setProvider = provider => routeProvider = provider;
    this.$get = () => routeProvider;
}
]);
