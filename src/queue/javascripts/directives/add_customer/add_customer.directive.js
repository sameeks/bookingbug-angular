angular.module('BBQueue.directives').directive('bbQueueAddCustomer', () => {
    return {
        controller: 'bbQueueAddCustomer',
        templateUrl: 'queue/add_customer.html',
        scope: {
            services: '=',
            servers: '=',
            company: '='
        }
    }
});
