angular.module('BBQueue.directives').directive('bbQueueDashboard', () => {
    return {
        controller: 'bbQueueDashboard',
        link: (scope, element, attrs) => {
            return scope.getSetup();
        }
    }
});
