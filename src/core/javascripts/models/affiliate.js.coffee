'use strict';

###**
* @ngdoc service
* @name BB.Models:Affiliate
*
* @description
* Representation of an Affiliate Object
*
* @property {string} affiliate_id Affiliated company id
* @property {string} reference The reference of the affiliated company
* @property {number} country_code Country code of the affiliated company
####

# helpful functions about a company
angular.module('BB.Models').factory "AffiliateModel", ($q, BBModel, BaseModel) ->

  class Affiliate extends BaseModel

    constructor: (data) ->
      super(data)
      @test = 1

    ###**
    * @ngdoc method
    * @name getCompanyByRef
    * @methodOf BB.Models:Affiliate
    * @description
    * Finds a company using the ref parameter.
    *
    * @param {string} ref A reference to find a company based on it
    *
    * @returns {promise} A promise that will be resolved to a response company object when the request succeeds
    ###
    getCompanyByRef: (ref) ->
      defer = $q.defer()
      @$get('companies', {reference: ref}).then (company) ->
        if company
          defer.resolve(new BBModel.Company(company))
        else
          defer.reject('No company for ref '+ref)
      , (err) ->
        console .log 'err ', err
        defer.reject(err)
      defer.promise
