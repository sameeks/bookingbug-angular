angular.module('BB.Directives').directive('bbPostcodeLookup', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'PostcodeLookup'
  })
);
