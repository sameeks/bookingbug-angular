angular.module('BBQueue.directives').directive('bbQueueServer', (PusherQueue) => {
    return {
        controller: 'bbQueueServer',
        link: (scope, element, attrs) => {
            let pusherListen = function(scope) {
                PusherQueue.subscribe(scope.bb.company);
                return PusherQueue.channel.bind('notification', data => {
                    return scope.getQueuers(scope.person);
                });
            };
            scope.getQueuers();
            return pusherListen(scope);
        }
    }
});
