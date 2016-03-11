'use strict';

###**
* @ngdoc service
* @name BB.Models:AdminAddress
*
* @description
* Representation of an Address Object
*
* @property {string} address1 First line of the address
* @property {string} address2 Second line of the address
* @property {string} address3 Third line of the address
* @property {string} address4 Fourth line of the address
* @property {string} address5 Fifth line of the address
* @property {string} postcode The Postcode/Zipcode
* @property {string} country The country
####

angular.module('BB.Models').factory "Admin.AddressModel", ($q, BBModel, BaseModel, AddressModel, AdminAddressService) ->


  class Admin_Address extends AddressModel

    ###**
    * @ngdoc method
    * @name distanceFrom
    * @methodOf BB.Models:AdminAddress
    * @param {string} address The admin address
    * @param {array} options The options of admin address
    * @description
    * Calculate the address distance in according of the address and options parameters
    *
    * @returns {array} Returns an array of address
    ###
    distanceFrom: (address, options) ->

      @dists ||= []
      @dists[address] ||= Math.round(Math.random() * 50, 0)
      return @dists[address]

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminAddress
    * @description
    * Static function that loads an array of addresses from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @query: (params) ->
      AdminAddressService.query(params)

angular.module('BB.Models').factory 'AdminAddress', ($injector) ->
  $injector.get('Admin.AddressModel')
