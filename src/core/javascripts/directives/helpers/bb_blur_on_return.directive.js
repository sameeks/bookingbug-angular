/***
* @ngdoc directive
* @name BB.Directives:bbBlurOnReturn
* @restrict A
* @scope true
*
* @description
* Removes focus from an input[type=text] element when return key is pressed
* @example
* <input type='text' bb-blur-on-return></div>
*///
angular.module('BB.Directives').directive('bbBlurOnReturn', $timeout =>
  ({
    restrict: 'A',
    require: 'ngModel',
    link(scope, el, attrs) {
      return el.keydown(function(e) {
        let key = e.which || e.keyCode;
        if ((key === 13) || (key === '13')) {
          return $timeout( function() {
            if (e.target) { return e.target.blur(); }
          }
          , 10
          );
        }
      });
    }
  })
);
