// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Models:Affiliate
 *
 * @description
 * Representation of an Affiliate Object
 *
 * @property {string} affiliate_id Id of the affiliated company
 * @property {string} reference The reference of the affiliated company
 * @property {integer} country_code Country code of the affiliated company
 *///


// helpful functions about a company
angular.module('BB.Models').factory("AffiliateModel", ($q, BBModel, BaseModel, halClient, $rootScope) =>

    class Affiliate extends BaseModel {

        constructor(data) {
            super(data);
            this.test = 1;
        }

        /***
         * @ngdoc method
         * @name getCompanyByRef
         * @methodOf BB.Models:Affiliate
         * @description
         * Find a company in according to reference
         *
         * @param {string} ref A reference to find a company based on it
         *
         * @returns {promise} A promise for the company reference
         */
        getCompanyByRef(ref) {

            let prms = {
                id: this.cookie,
                reference: ref
            };

            let href = `${$rootScope.bb.api_url}/api/v1/affiliates/{id}/companies/{reference}`;
            let uri = new UriTemplate(href).fillFromObject(prms || {});

            let defer = $q.defer();

            halClient.$get(uri, {}).then(function (company) {
                    if (company) {
                        return defer.resolve(new BBModel.Company(company));
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
    }
);

