// build a dynamic injector for each of the models!
// This creates a service that is capable of creating any given model
// It uses dynamic injection, to avoid a cuicular dependancy - as any model, needs to be able to create instances of other models


angular.module('BB.Models').service("BBModel", function ($q, $injector) {
});


angular.module('BB.Models').run(function ($q, $injector, BBModel) {

    // the top level models
    let models = ['Address', 'Answer', 'Affiliate', 'Basket', 'BasketItem',
        'BookableItem', 'Category', 'Client', 'ClientDetails', 'Company',
        'CompanySettings', 'Day', 'Event', 'EventChain', 'EventGroup',
        'EventTicket', 'EventSequence', 'ItemDetails', 'PaymentCallbacks', 'Person', 'PurchaseItem',
        'PurchaseTotal', 'Question', 'Resource', 'Service', 'Slot', 'Space',
        'Clinic', 'SurveyQuestion', 'TimeSlot', 'BusinessQuestion', 'Image', 'Deal',
        'PrePaidBooking', 'MembershipLevel', 'Product', 'BBCollection',
        'ExternalPurchase', 'PackageItem', 'BulkPurchase', 'Pagination', 'Reason',
        'Login'];

    for (var model of Array.from(models)) {
        BBModel[model] = $injector.get(model + "Model");
    }

    // purchase models
    let purchase_models = ['Booking', 'Total', 'CourseBooking'];
    let pfuncs = {};
    for (model of Array.from(purchase_models)) {
        pfuncs[model] = $injector.get(`Purchase.${model}Model`);
    }
    return BBModel['Purchase'] = pfuncs;
});


//###########################
// The Base Model

// this provides some helpful functions to the models, that map various undelrying HAL resource functions

angular.module('BB.Models').service("BaseModel", ($q, $injector, $rootScope, $timeout) =>

    class Base {

        constructor(data) {
            this.deleted = false;
            this.updateModel(data);
        }

        updateModel(data) {
            if (data) {
                this._data = data;
            }
            if (data) {
                for (let n in data) {
                    let m = data[n];
                    if (typeof(m) !== 'function') {
                        this[n] = m;
                    }
                }
            }
            if (this._data && this._data.$href) {
                this.self = this._data.$href("self");
                // append get functions for all links...
                // for exmaple if the embedded object contains a link to 'people' we create two functions:
                // getPeople()  - which resolves eventaully to an array of People (this may take a few digest loops). This is good for use in views
                // getPeoplePromise()  -  which always returns a promise of the object - which is useful in controllers
                let links = this.$links();
                this.__linkedData = {};
                this.__linkedPromises = {};
                return (() => {
                    let result = [];
                    for (let link in links) {
                        let obj = links[link];
                        let name = this._snakeToCamel(`get_${link}`);
                        result.push(((link, obj, name) => {
                            if (!this[name]) {
                                this[name] = function (options) {
                                    return this.$buildOject(link, options);
                                };
                            }
                            if (!this[`$${name}`]) {
                                return this[`$${name}`] = function (options) {
                                    return this.$buildOjectPromise(link, options);
                                };
                            }
                        })(link, obj, name));
                    }
                    return result;
                })();
            }
        }


        _snakeToCamel(s) {
            return s.replace(/(\_\w)/g, m => m[1].toUpperCase());
        }


        // build out a linked object
        $buildOject(link, options) {
            let linkId = link + (JSON.stringify(options) || '');

            if (this.__linkedData[linkId]) {
                return this.__linkedData[linkId];
            }
            this.$buildOjectPromise(link, options).then(ans => {
                    this.__linkedData[linkId] = ans;
                    // re-set it again with a digest loop - jsut to be sure!
                    return $timeout(() => {
                            return this.__linkedData[linkId] = ans;
                        }
                    );
                }
            );
            return null;
        }

        // build a promise for a linked object
        $buildOjectPromise(link, options) {
            let linkId = link + (JSON.stringify(options) || '');

            if (this.__linkedPromises[linkId]) {
                return this.__linkedPromises[linkId];
            }
            let prom = $q.defer();
            this.__linkedPromises[linkId] = prom.promise;

            this.$get(link, options).then(res => {
                    let inj = $injector.get(`BB.Service.${link}`);
                    if (inj) {
                        if (inj.promise) {
                            // unwrap involving another promise
                            return inj.unwrap(res).then(ans => prom.resolve(ans)
                                , err => prom.reject(err));
                        } else {
                            // unwrap without a promise
                            return prom.resolve(inj.unwrap(res));
                        }
                    } else {
                        // no service found - just return the resources as I found it
                        return prom.resolve(res);
                    }
                }
                , err => prom.reject(err));

            return this.__linkedPromises[linkId];
        }


        get(ikey) {
            if (!this._data) {
                return null;
            }
            return this._data[ikey];
        }

        set(ikey, value) {
            if (!this._data) {
                return null;
            }
            return this._data[ikey] = value;
        }

        getOption(ikey) {
            if (!this._data) {
                return null;
            }
            return this._data.getOption(ikey);
        }

        setOption(ikey, value) {
            if (!this._data) {
                return null;
            }
            return this._data.setOption(ikey, value);
        }


        $href(rel, params) {
            if (this._data) {
                return this._data.$href(rel, params);
            }
        }

        $has(rel) {
            if (this._data) {
                return this._data.$has(rel);
            }
        }

        $flush(rel, params) {
            if (this._data) {
                return this._data.$flush(rel, params);
            }
        }

        $get(rel, params) {
            if (this._data) {
                return this._data.$get(rel, params);
            }
        }

        $post(rel, params, dat) {
            if (this._data) {
                return this._data.$post(rel, params, dat);
            }
        }

        $put(rel, params, dat) {
            if (this._data) {
                return this._data.$put(rel, params, dat);
            }
        }

        $patch(rel, params, dat) {
            if (this._data) {
                return this._data.$patch(rel, params, dat);
            }
        }

        $del(rel, params, dat) {
            if (this._data) {
                return this._data.$del(rel, params, dat);
            }
        }

        $links() {
            if (this._data) {
                return this._data.$links();
            }
        }

        $link(rel) {
            if (this._data) {
                return this._data.$link(rel);
            }
        }

        $toStore() {
            if (this._data) {
                return this._data.$toStore();
            }
        }
    }
);

