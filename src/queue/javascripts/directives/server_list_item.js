angular.module('BBQueue.directives').directive('bbServerListItem', () => {
    return {
        controller: 'bbQueueServerController',
        templateUrl: 'queue/queue_server_list_item.html'
    }
});
