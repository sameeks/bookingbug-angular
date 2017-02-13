angular.module('BB.Directives').directive('bbHeader', $compile =>
    ({
      link(scope, element, attr) {
        scope.bb.waitForRoutes();
        return scope.$watch('bb.path_setup', (newval, oldval) => {
          if (newval) {
            element.attr('ng-include', `'${scope.getPartial(attr.bbHeader)}'`);
            element.attr('bb-header',null);
            return $compile(element)(scope);
          }
        }
        );
      }
    })
);
