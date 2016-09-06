'use strict'

###**
* @ngdoc service
* @name BB.Services:PathHelper
*
* @description
* Helper service for retrieving params from $location.path 
*
###

angular.module('BB.Services').factory 'PathHelper', ($urlMatcherFactory, $location) ->

  ###**
    * @ngdoc method
    * @name matchRouteToPath
    * @methodOf BB.Services:PathHelper
    * @description
    * Get the email pattern
    * @param {string} the route format
    * @param {string} optional argument specifying the param to return from the path if matched, e.g. 'page'
    *
    * @returns {Object} the match object or matched param
  ###
  matchRouteToPath: (route_format, param) ->

    return false if !$location.path() or !route_format

    parts = route_format.split("/")
    match = null

    while parts.length > 0 and !match
      match_test = parts.join("/")
      pattern = $urlMatcherFactory.compile(match_test)
      match = pattern.exec($location.path())
      parts.pop()

    if match[param]
      return match[param]
    else
      return match

