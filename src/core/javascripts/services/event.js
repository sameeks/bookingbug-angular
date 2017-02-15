angular.module('BB.Services').factory("EventService", ($q, BBModel) => {

        return {
            query(company, params) {
                let deferred = $q.defer();
                if (!company.$has('events')) {
                    deferred.resolve([]);
                } else {
                    if (params.item) {
                        if (params.item.event_group) {
                            params.event_group_id = params.item.event_group.id;
                        }
                        if (params.item.event_chain) {
                            params.event_chain_id = params.item.event_chain.id;
                        }
                        if (params.item.resource) {
                            params.resource_id = params.item.resource.id;
                        }
                        if (params.item.person) {
                            params.person_id = params.item.person.id;
                        }
                    }
                    params.no_cache = true;
                    company.$get('events', params).then(resource => {
                            params.no_cache = false;
                            return resource.$get('events', params).then(events => {
                                    events = (Array.from(events).map((event) => new BBModel.Event(event)));
                                    return deferred.resolve(events);
                                }
                            );
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
                return deferred.promise;
            },

            summary(company, params) {
                let deferred = $q.defer();
                if (!company.$has('events')) {
                    deferred.resolve([]);
                } else {
                    if (params.item) {
                        if (params.item.event_group) {
                            params.event_group_id = params.item.event_group.id;
                        }
                        if (params.item.event_chain) {
                            params.event_chain_id = params.item.event_chain.id;
                        }
                        if (params.item.resource) {
                            params.resource_id = params.item.resource.id;
                        }
                        if (params.item.person) {
                            params.person_id = params.item.person.id;
                        }
                    }
                    params.summary = true;
                    company.$get('events', params).then(resource => {
                            return deferred.resolve(resource.events);
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
                return deferred.promise;
            },

            queryEventCollection(company, params) {
                let deferred = $q.defer();
                if (!company.$has('events')) {
                    deferred.resolve([]);
                } else {
                    if (params.item) {
                        if (params.item.event_group) {
                            params.event_group_id = params.item.event_group.id;
                        }
                        if (params.item.event_chain) {
                            params.event_chain_id = params.item.event_chain.id;
                        }
                        if (params.item.resource) {
                            params.resource_id = params.item.resource.id;
                        }
                        if (params.item.person) {
                            params.person_id = params.item.person.id;
                        }
                    }
                    company.$get('events', params).then(resource => {
                            let collection = new BBModel.BBCollection(resource);
                            return deferred.resolve(collection);
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                }
                return deferred.promise;
            }
        };
    }
);

