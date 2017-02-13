// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbInclude', ($compile, $rootScope) =>
  ({
    link(scope, element, attr) {
      let track_page = (attr.bbTrackPage != null) ? true : false;
      return scope.$watch('bb.path_setup', (newval, oldval) => {
        if (newval) {
          element.attr('ng-include', `'${scope.getPartial(attr.bbInclude)}'`);
          element.attr('bb-include',null);
          $compile(element)(scope);
          if (track_page) { return $rootScope.$broadcast("page:loaded", attr.bbInclude); }
        }
      }
      );
    }
  })
);
