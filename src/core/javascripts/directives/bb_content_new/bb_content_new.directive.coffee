'use strict'

# Used to load the application's content. It uses ng-include.
angular.module('BB.Directives').directive 'bbContentNew', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : true
  templateUrl : PathSvc.directivePartial "content_main"
  controller : ($scope)->
    $scope.initPage = ->
      $scope.$eval('setPageLoaded()')
    return

