angular.module('BB.Directives').directive('bbPostcodeLookup', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'PostcodeLookup'
        };
    }
);
