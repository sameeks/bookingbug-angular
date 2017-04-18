angular.module('BBQueue.directives').directive('bbQueuers', (PusherQueue) => {
    return {
        controller: 'bbQueuers',
        link: (scope, element, attrs) => {
            PusherQueue.subscribe(scope.bb.company);
            PusherQueue.channel.bind('notification', data => {
                scope.getQueuers();
            });
        },
        templateUrl: 'queue/queuers.html'
    };
});
