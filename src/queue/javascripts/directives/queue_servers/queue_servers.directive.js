angular.module('BBQueue.directives').directive('bbQueueServers', () => {
    return {
        controller: 'bbQueueServers',
        link: (scope, element, attrs) => {
            return scope.getServers();
        },
        templateUrl: 'queue/queue_servers.html'
    }
});
