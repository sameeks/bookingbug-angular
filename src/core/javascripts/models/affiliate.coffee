'use strict'


###**
* @ngdoc service
* @name BB.Models:Affiliate
*
* @description
* Representation of an Affiliate Object
*
* @property {string} affiliate_id Id of the affiliated company
* @property {string} reference The reference of the affiliated company
* @property {integer} country_code Country code of the affiliated company
####


# helpful functions about a company
angular.module('BB.Models').factory "AffiliateModel", ($q, BBModel, BaseModel, halClient, $rootScope) ->

  class Affiliate extends BaseModel

    constructor: (data) ->
      super(data)
      @test = 1

    ###**
    * @ngdoc method
    * @name getCompanyByRef
    * @methodOf BB.Models:Affiliate
    * @description
    * Find a company in according to reference
    *
    * @param {string} ref A reference to find a company based on it
    *
    * @returns {promise} A promise for the company reference
    ###
    getCompanyByRef: (ref) ->

      prms = {
        id: @cookie
        reference: ref
      }

      href = "#{$rootScope.bb.api_url}/api/v1/affiliates/{id}/companies/{reference}"
      uri = new UriTemplate(href).fillFromObject(prms || {})

      defer = $q.defer()

      halClient.$get(uri, {}).then (company) ->
        if company
          defer.resolve(new BBModel.Company(company))
        else
          defer.reject('No company for ref '+ref)
      , (err) ->
        console .log 'err ', err
        defer.reject(err)
      defer.promise

