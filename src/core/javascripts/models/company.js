/***
 * @ngdoc service
 * @name BB.Models:Company
 *
 * @description
 * Representation of an Company Object
 *
 * @constructor
 * @param {HALobject=} data A HAL object to initialise the company from
 *
 * @property {string} name The company name
 * @property {string} description The company description
 * @property {string} country_code the Country code for thie company
 * @property {string} currency_code A CCY for this company
 * @property {string} reference A custom external reference for the company
 * @property {integer} id The company ID
 * @property {boolean} live If this company is set live
 * @property {array} companies An array of child companies if this is a parent company
 * @property {string} timezone The timezone for the business
 *///


// helpful functions about a company
angular.module('BB.Models').factory("CompanyModel", ($q, BBModel, BaseModel, halClient, AppConfig, $sessionStorage, CompanyService) =>

    class Company extends BaseModel {

        constructor(data) {
            super(data);
            // instantiate each child company as a hal resource
            // we'll set the @companies array to all companies - including grandchildren
            // and we'll have an array called child_companies that contains only direct ancesstors
            if (this.companies) {
                let all_companies = [];
                this.child_companies = [];
                for (let comp of Array.from(this.companies)) {
                    let c = new BBModel.Company(halClient.$parse(comp));
                    this.child_companies.push(c);
                    if (c.companies) {
                        // if that company has it's own child companies
                        for (let child of Array.from(c.companies)) {
                            all_companies.push(child);
                        }
                    } else {
                        all_companies.push(c);
                    }
                }
                this.companies = all_companies;
            }
        }

        /***
         * @ngdoc method
         * @name getCompanyByRef
         * @methodOf BB.Models:Company
         * @description
         * Find a child company by reference
         *
         * @returns {promise} A promise for the child company
         */
        getCompanyByRef(ref) {
            let defer = $q.defer();
            this.$get('companies').then(function (companies) {
                    let company = _.find(companies, c => c.reference === ref);
                    if (company) {
                        return defer.resolve(company);
                    } else {
                        return defer.reject(`No company for ref ${ref}`);
                    }
                }
                , function (err) {
                    console.log('err ', err);
                    return defer.reject(err);
                });
            return defer.promise;
        }

        /***
         * @ngdoc method
         * @name findChildCompany
         * @methodOf BB.Models:Company
         * @description
         * Find a child company by id
         *
         * @returns {object} The child company
         */
        findChildCompany(id) {
            if (!this.companies) {
                return null;
            }
            for (var c of Array.from(this.companies)) {
                if (c.id === parseInt(id)) {
                    return c;
                }
                if (c.ref && (c.ref === String(id))) {
                    return c;
                }
            }
            // failed to find by id - maybe by name ?
            if (typeof id === "string") {
                let name = id.replace(/[\s\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '').toLowerCase();
                for (c of Array.from(this.companies)) {
                    let cname = c.name.replace(/[\s\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|'’!<>;:,.~`=+-@£&%"]/g, '').toLowerCase();
                    if (name === cname) {
                        return c;
                    }
                }
            }
            return null;
        }

        /***
         * @ngdoc method
         * @name getSettings
         * @methodOf BB.Models:Company
         * @description
         * Get settings company
         *
         * @returns {promise} A promise for settings company
         */
        getSettings() {
            let def = $q.defer();
            if (this.settings) {
                def.resolve(this.settings);
            } else {
                if (this.$has('settings')) {
                    this.$get('settings').then(set => {
                            this.settings = new BBModel.CompanySettings(set);
                            return def.resolve(this.settings);
                        }
                    );
                } else {
                    def.reject("Company has no settings");
                }
            }
            return def.promise;
        }

        /***
         * @ngdoc method
         * @name pusherSubscribe
         * @methodOf BB.Models:Company
         * @description
         * Push subscribe for company
         *
         * @returns {object} Subscriber company
         */
        pusherSubscribe(callback, options) {
            if (options == null) {
                options = {};
            }
            if ((typeof Pusher !== 'undefined' && Pusher !== null) && (this.pusher == null)) {
                if (!this.$has('pusher')) {
                    return;
                }
                this.pusher = new Pusher('c8d8cea659cc46060608', {
                        encrypted: options.hasOwnProperty('encrypted') ? options.encrypted : true,
                        authEndpoint: this.$link('pusher').href,
                        auth: {
                            headers: {
                                'App-Id': AppConfig.appId,
                                'App-Key': AppConfig.appKey,
                                'Auth-Token': $sessionStorage.getItem('auth_token')
                            }
                        }
                    }
                );
            }

            let channelName = `private-c${this.id}-w${this.numeric_widget_id}`;

            // Nuke the channel if it exists, must be done if this is to be used in multiple pages
            // this is being delt differently in the newer implementation
            if (this.pusher.channel(channelName) != null) {
                this.pusher.unsubscribe(channelName);
            }

            this.pusher_channel = this.pusher.subscribe(channelName);
            this.pusher_channel.bind('booking', callback);
            this.pusher_channel.bind('cancellation', callback);
            return this.pusher_channel.bind('updating', callback);
        }


        /***
         * @ngdoc method
         * @name getPusherChannel
         * @methodOf BB.Models:Company
         *
         * @returns {object} Pusher channel
         */
        getPusherChannel(model, options) {
            if (options == null) {
                options = {};
            }
            if (!this.pusher) {
                if (!this.$has('pusher')) {
                    return;
                }
                this.pusher = new Pusher('c8d8cea659cc46060608', {
                        encrypted: options.hasOwnProperty('encrypted') ? options.encrypted : true,
                        authEndpoint: this.$link('pusher').href,
                        auth: {
                            headers: {
                                'App-Id': AppConfig.appId,
                                'App-Key': AppConfig.appKey,
                                'Auth-Token': $sessionStorage.getItem('auth_token')
                            }
                        }
                    }
                );
            }
            if (this.$has(model)) {
                let channelName = this.$href(model);
                channelName = channelName.replace(/https?:\/\//, '').replace(/\//g, '-').replace(/:/g, '_');
                if (this.pusher.channel(channelName)) {
                    return this.pusher.channel(channelName);
                } else {
                    this.pusher.subscribe(channelName);
                    return this.pusher.channel(channelName);
                }
            }
        }

        static $query(company_id, options) {
            return CompanyService.query(company_id, options);
        }
    }
);

