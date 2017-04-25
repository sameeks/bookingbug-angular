angular.module('BBQueue.directives').directive('bbQueueServer', (PusherQueue) => {
    return {
        controller: 'bbQueueServerController',
        link: (scope, element, attrs) => {
            PusherQueue.subscribe(scope.bb.company);
            PusherQueue.channel.bind('notification', data => {
                scope.updateQueuer();
            });
            scope.updateQueuer();
        }
    };
});
