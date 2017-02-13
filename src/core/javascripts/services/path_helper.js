// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Services:PathHelper
*
* @description
* Helper service for retrieving params from $location.path 
*
*/

angular.module('BB.Services').factory('PathHelper', ($urlMatcherFactory, $location) =>

  ({
    /***
      * @ngdoc method
      * @name matchRouteToPath
      * @methodOf BB.Services:PathHelper
      * @description
      * Get the email pattern
      * @param {string} the route format
      * @param {string} optional argument specifying the param to return from the path if matched, e.g. 'page'
      *
      * @returns {Object} the match object or matched param
    */
    matchRouteToPath(route_format, param) {

      if (!$location.path() || !route_format) { return false; }

      let parts = route_format.split("/");
      let match = null;

      while ((parts.length > 0) && !match) {
        let match_test = parts.join("/");
        let pattern = $urlMatcherFactory.compile(match_test);
        match = pattern.exec($location.path());
        parts.pop();
      }

      if (match[param]) {
        return match[param];
      } else {
        return match;
      }
    }
  })
);

