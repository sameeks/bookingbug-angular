'use strict'

angular.module('BB.Directives').directive 'bbPaypalExpressButton', ($compile,
  $sce, $http, $templateCache, $q, $log, $window, UriTemplate) ->

  restrict: 'EA'
  replace: true
  template: """
    <a ng-href="{{href}}" ng-click="showLoader()">Pay</a>
  """
  scope:
    total: '='
    bb: '='
    decideNextPage: '='
    paypalOptions: '=bbPaypalExpressButton'
    notLoaded: '='
  link: (scope, element, attributes) ->

    total = scope.total
    paypalOptions = scope.paypalOptions
    scope.href = new UriTemplate(total.$link('paypal_express').href).fillFromObject(paypalOptions)

    scope.showLoader = () ->
      scope.notLoaded scope if scope.notLoaded
