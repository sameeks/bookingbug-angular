// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbDebounce', $timeout =>
  ({
    restrict: 'A',
    link(scope, element, attrs) {
      let delay = 400;
      if (attrs.bbDebounce) { delay = attrs.bbDebounce; }

      return element.bind('click', () => {
        $timeout(() => {
          return element.attr('disabled', true);
        }
        , 0);
        return $timeout(() => {
          return element.attr('disabled', false);
        }
        , delay);
      }
      );
    }
  })
);
