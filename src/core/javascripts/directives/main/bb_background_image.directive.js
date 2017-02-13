// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbBackgroundImage
* @restrict A
* @scope true
*
* @description
* Adds a background-image to an element

* @param
* {string} url
*
* @example
* <div bb-background-image='images/example.jpg'></div>
*///
angular.module('BB.Directives').directive('bbBackgroundImage', () =>
    ({
      restrict: 'A',
      scope: true,
      link(scope, el, attrs) {
        let killWatch;
        if (!attrs.bbBackgroundImage || (attrs.bbBackgroundImage === "")) { return; }
        return killWatch = scope.$watch(attrs.bbBackgroundImage, function(new_val, old_val) {
          if (new_val) {
            killWatch();
            return el.css('background-image', `url("${new_val}")`);
          }
        });
      }
    })
);
