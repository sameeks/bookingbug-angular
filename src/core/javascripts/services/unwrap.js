angular.module('BB.Services').factory("UnwrapService", ($q, BBModel) => {
        return {
            unwrapCollection(model, key, resource) {
                let models;
                let deferred = $q.defer();

                // if the resource is embedded, return the array of models
                if (angular.isArray(resource)) {

                    models = (Array.from(resource).map((service) => new model(service)));
                    deferred.resolve(models);

                } else if (resource.$has(key)) {
                    resource.$get(key).then(items => {
                            models = [];
                            for (let i of Array.from(items)) {
                                models.push(new model(i));
                            }
                            return deferred.resolve(models);
                        }
                        , err => {
                            return deferred.reject(err);
                        }
                    );
                } else {
                    deferred.reject();
                }

                return deferred.promise;
            },

            unwrapResource(model, resource) {
                return new model(resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.address", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Address, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.addresses", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Address, 'addresses', resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.person", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Person, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.people", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Person, 'people', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.resource", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Resource, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.resources", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Resource, 'resources', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.service", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Service, resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.services", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Service, 'services', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.package_item", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.PackageItem, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.package_items", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.PackageItem, 'package_items', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.bulk_purchase", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.BulkPurchase, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.bulk_purchases", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.BulkPurchase, 'bulk_purchases', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.event_group", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.EventGroup, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.event_groups", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.EventGroup, 'event_groups', resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.event_chain", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.EventChain, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.event_chains", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.EventChain, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.category", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Category, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.categories", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Category, 'categories', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.client", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Client, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.child_clients", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Client, 'clients', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.clients", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Client, 'clients', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.questions", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Question, 'questions', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.question", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Question, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.answers", ($q, BBModel, UnwrapService) => {
        return {
            promise: false,
            unwrap(items) {
                let models = [];
                for (let i of Array.from(items)) {
                    models.push(new BBModel.Answer(i));
                }
                let answers = {
                    answers: models,

                    getAnswer(question) {
                        for (let a of Array.from(this.answers)) {
                            if ((a.question_text === question) || (a.question_id === question)) {
                                return a.value;
                            }
                        }
                    }
                };

                return answers;
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.administrators", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(items) {
                return Array.from(items).map((i) => new BBModel.Admin.User(i));
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.company", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Company, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.parent", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Company, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.company_questions", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.BusinessQuestion, 'company_questions', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.company_question", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.BusinessQuestion, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.images", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Image, 'images', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.bookings", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Member.Booking, 'bookings', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.wallet", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Member.Wallet, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.product", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.Product, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.products", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                let deferred = $q.defer();
                resource.$get('products').then(items => {
                        let models = [];
                        for (let index = 0; index < items.length; index++) {
                            let i = items[index];
                            let cat = new BBModel.Product(i);
                            if (!cat.order) {
                                cat.order = index;
                            }
                            models.push(cat);
                        }
                        return deferred.resolve(models);
                    }
                    , err => {
                        return deferred.reject(err);
                    }
                );

                return deferred.promise;
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.pre_paid_booking", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.PrePaidBooking, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.pre_paid_bookings", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.PrePaidBooking, 'pre_paid_bookings', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.external_purchase", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.ExternalPurchase, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.external_purchases", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.ExternalPurchase, 'external_purchases', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.purchase_item", ($q, BBModel, UnwrapService) => {
        return {
            unwrap(resource) {
                return UnwrapService.unwrapResource(BBModel.PurchaseItem, resource);
            }
        };
    }
);


angular.module('BB.Services').factory("BB.Service.purchase_items", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.PurchaseItem, 'purchase_items', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.payment_callbacks", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.PaymentCallbacks, 'payment_callbacks', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.events", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Event, 'events', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.all_children", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Service, 'services', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.child_services", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Service, 'child_services', resource);
            }
        };
    }
);

angular.module('BB.Services').factory("BB.Service.items", ($q, BBModel, UnwrapService) => {
        return {
            promise: true,
            unwrap(resource) {
                return UnwrapService.unwrapCollection(BBModel.Items, 'items', resource);
            }
        };
    }
);
