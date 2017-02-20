angular.module('BB.Directives').directive('bbCustomConfirmationText', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'CustomConfirmationText'
        };
    }
);
