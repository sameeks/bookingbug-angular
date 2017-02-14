// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("AdminClientModel", (ClientModel, $q, BBModel, $log, $window, ClientCollections, $rootScope, UriTemplate, halClient) =>

    class Admin_Client extends ClientModel {

        constructor(data) {
            super(data);
        }

        static $query(params) {
            let {company} = params;
            let defer = $q.defer();

            if (company.$has('client')) {

                //if params.flush
                //  company.$flush('client', params)

                // have to use a hard coded api ref for now until all servers also have the {/id} in the href

                let url = "";
                if ($rootScope.bb.api_url) {
                    url = $rootScope.bb.api_url;
                }
                let href = url + "/api/v1/admin/{company_id}/client{/id}{?page,per_page,filter_by,filter_by_fields,order_by,order_by_reverse,search_by_fields,default_company_id}";
                params.company_id = company.id;
                let uri = new UriTemplate(href).fillFromObject(params || {});

                if (params.flush) {
                    halClient.clearCache(uri);
                }

                //company.$get('client', params).then (resource) ->
                halClient.$get(uri, {}).then(resource => {
                        if (resource.$has('clients')) {
                            return resource.$get('clients').then(function (clients) {
                                    let models = (Array.from(clients).map((c) => new BBModel.Admin.Client(c)));

                                    clients = new $window.Collection.Client(resource, models, params);
                                    clients.total_entries = resource.total_entries;
                                    ClientCollections.add(clients);
                                    return defer.resolve(clients);
                                }
                                , err => defer.reject(err));
                        } else {
                            let client = new BBModel.Admin.Client(resource);
                            return defer.resolve(client);
                        }
                    }
                    , err => defer.reject(err));
            } else {
                $log.warn('company has no client link');
                defer.reject('company has no client link');
            }
            return defer.promise;
        }
    }
);



