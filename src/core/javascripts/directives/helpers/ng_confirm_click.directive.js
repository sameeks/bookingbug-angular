angular.module('BB.Directives').directive('ngConfirmClick', () =>
  ({
    link(scope, element, attr) {
      let msg = attr.ngConfirmClick || "Are you sure?";
      let clickAction = attr.ngConfirmedClick;
      return element.bind('click', event => {
        if (window.confirm(msg)) {
          return scope.$eval(clickAction);
        }
      }
      );
    }
  })
);
