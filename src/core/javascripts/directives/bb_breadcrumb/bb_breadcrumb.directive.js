'use strict'

angular.module('BB.Directives').directive 'bbBreadcrumbs', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : true
  controller : 'Breadcrumbs'
  templateUrl : (element, attrs) ->
    if _.has attrs, 'complex'
    then PathSvc.directivePartial "_breadcrumb_complex"
    else PathSvc.directivePartial "_breadcrumb"

  link : (scope) ->
    return
