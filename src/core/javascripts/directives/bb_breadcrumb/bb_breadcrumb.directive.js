// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbBreadcrumbs', PathSvc =>
  ({
    restrict: 'A',
    replace: true,
    scope : true,
    controller : 'Breadcrumbs',
    templateUrl(element, attrs) {
      if (_.has(attrs, 'complex')) {
      return PathSvc.directivePartial("_breadcrumb_complex");
      } else { return PathSvc.directivePartial("_breadcrumb"); }
    },

    link(scope) {
      
    }
  })
);
