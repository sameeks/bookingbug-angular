/***
* @ngdoc directive
* @name BB.Directives.directive:autofocus
* @scope
* @restrict A
*
* @description
* Enables the HTML5 autofocus property to work with dynamically loaded content
*
* Usage:
* <input type="text" autofocus="isTrue">
*
*/
angular.module('BB.Directives')
.directive('autofocus', $timeout =>
  ({
    restrict: 'A',
    link(scope, element, attr) {
      return $timeout(function() {
        if ((attr.autofocus === '') || scope.$eval(attr.autofocus)) {
          return element[0].focus();
        }
      });
    }
  }));

