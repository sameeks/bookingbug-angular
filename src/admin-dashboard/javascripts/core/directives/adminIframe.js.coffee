'use strict'

###
 * @ngdoc directive
 * @name BBAdminDashboard.directives.directive:adminIframe
 * @scope
 * @restrict A
 *
 * @description
 * Ensures iframe size is based on iframe content and that the iframe src is whitelisted
 *
 * @param {string}  path         A string that contains the iframe url
 * @param {string}  apiUrl       A string that contains the ApiUrl
 * @param {object}  extraParams  An object that contains extra params for the url (optional)
###
angular.module('BBAdminDashboard.directives').directive 'adminIframe', ['$window', '$timeout', ($window, $timeout) ->
  {
    restrict: 'A'
    scope:
      path: '='
      apiUrl: '='
      extraParams: '=?'
    templateUrl: 'core/admin-iframe.html'  
    controller: ['$scope', '$sce', ($scope, $sce) ->
      $scope.frameSrc = $sce.trustAsResourceUrl($scope.apiUrl + '/' + unescape($scope.path) + "?whitelabel=adminlte&uiversion=aphid&#{$scope.extraParams if $scope.extraParams}")
    ]  
    link: (scope, element, attrs) ->
      $window.addEventListener 'message', (event) ->
        if event.data.height
          element.height(event.data.height + 'px')
      return
  }
]