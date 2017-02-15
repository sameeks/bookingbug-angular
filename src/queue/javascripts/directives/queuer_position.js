angular.module('BBQueue.Directives').directive('bbQueuerPosition', () => {

        return {
            restrict: 'AE',
            replace: true,
            controller: 'QueuerPosition',
            templateUrl: 'public/queuer_position.html',
            scope: {
                id: '=',
                apiUrl: '@'
            }
        };
    }
);

