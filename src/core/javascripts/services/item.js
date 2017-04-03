angular.module('BB.Services').factory("ItemService", ($q, BBModel, $rootScope, halClient) => {
        return {
            query(prms) {
                let deferred = $q.defer();
              
                var extra = {};
                extra.company_id  = prms.company.id;
                if (angular.isObject(prms.cItem.resource))
                    extra.resource_id = prms.cItem.resource.id ;
                if (angular.isObject(prms.cItem.person))
                    extra.person_id   = prms.cItem.person.id ;
                if (angular.isObject(prms.cItem.service))     
                    extra.service_id  = prms.cItem.service.id ;

                var href = $rootScope.bb.api_url + "/api/v1/";
                href += "{company_id}/items{?service_id,resource_id,person_id}";
                var uri = new UriTemplate(href).fillFromObject(extra || {});

                if (prms.cItem.person && !prms.cItem.anyPerson() && (prms.item !== 'person')) {                   
                    if (!prms.cItem.person.$has('items')) {                                       
                        halClient.$get(uri, extra).then(base_item => {
                             return this.build_items(base_item, prms, deferred);
                        });                                                    
                    } else {
                        this.build_items(prms.cItem.person.$get('items'), prms, deferred);
                    }
                } 
                 else if (prms.cItem.resource && !prms.cItem.anyResource() && (prms.item !== 'resource')) {
                    if (!prms.cItem.resource.$has('items')) {
                        halClient.$get(uri, extra).then(base_item => {
                             return this.build_items(base_item, prms, deferred);
                        });  
                    } else {
                        this.build_items(prms.cItem.resource.$get('items'), prms, deferred);
                    }

                } else if (prms.cItem.service && (prms.item !== 'service')) {
                    if (!prms.cItem.service.$has('items')) {
                        prms.cItem.service.$get('item').then(base_item => {
                                return this.build_items(base_item.$get('items'), prms, deferred);
                            }
                        );
                    } else {
                        this.build_items(prms.cItem.service.$get('items'), prms, deferred);
                    }
                } else {
                    deferred.reject("No service link found");
                }

                return deferred.promise;
            },

            build_items(base_items, prms, deferred) {
                let wait_items = [base_items];
                if (prms.wait) {
                    wait_items.push(prms.wait);
                }
                return $q.all(wait_items).then(resources => {
                        let resource = resources[0];  // the first one was my own data
                        return resource.$get('items').then(found => {
                                let matching = [];
                                for (let v of Array.from(found)) {
                                    if (v.type === prms.item) {
                                        matching.push(new BBModel.BookableItem(v));
                                    }
                                }
                                return $q.all((Array.from(matching).map((m) => m.ready.promise))).then(() => deferred.resolve(matching));
                            }
                        );
                    }
                );
            }
        };
    }
);

