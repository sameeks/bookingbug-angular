angular.module('BBQueue.services').factory('PusherQueue', function ($sessionStorage, AppConfig) {
    return class PusherQueue {
        static subscribe(company) {
            if ((company != null) && (typeof Pusher !== 'undefined' && Pusher !== null)) {
                if (this.client == null) {
                    this.pusher = new Pusher('c8d8cea659cc46060608', {
                        authEndpoint: `/api/v1/push/${company.id}/pusher.json`,
                        auth: {
                            headers: {
                                'App-Id': AppConfig['App-Id'],
                                'App-Key': AppConfig['App-Key'],
                                'Auth-Token': $sessionStorage.getItem('auth_token')
                            }
                        }
                    });
                    return this.channel = this.pusher.subscribe(`mobile-queue-${company.id}`);
                }
            }
        }
    };
});
