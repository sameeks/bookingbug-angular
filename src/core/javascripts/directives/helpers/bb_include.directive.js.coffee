'use strict'

angular.module('BB.Directives').directive 'bbInclude', ($compile, $rootScope) ->
  link: (scope, element, attr) ->
    track_page = if attr.bbTrackPage? then true else false
    scope.$watch 'bb.path_setup', (newval, oldval) =>
      if newval
        element.attr('ng-include', "'" + scope.getPartial(attr.bbInclude) + "'")
        element.attr('bb-include',null)
        $compile(element)(scope)
        $rootScope.$broadcast "page:loaded", attr.bbInclude if track_page
