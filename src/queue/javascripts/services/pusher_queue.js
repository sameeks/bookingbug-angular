// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBQueue.Services').factory('PusherQueue', ($sessionStorage, $pusher, AppConfig) =>

    class PusherQueue {

        static subscribe(company) {
            if ((company != null) && (typeof Pusher !== 'undefined' && Pusher !== null)) {
                if (this.client == null) {
                    this.client = new Pusher('c8d8cea659cc46060608', {
                            authEndpoint: `/api/v1/push/${company.id}/pusher.json`,
                            auth: {
                                headers: {
                                    'App-Id': AppConfig['App-Id'],
                                    'App-Key': AppConfig['App-Key'],
                                    'Auth-Token': $sessionStorage.getItem('auth_token')
                                }
                            }
                        }
                    );
                }

                this.pusher = $pusher(this.client);
                return this.channel = this.pusher.subscribe(`mobile-queue-${company.id}`);
            }
        }
    }
);

