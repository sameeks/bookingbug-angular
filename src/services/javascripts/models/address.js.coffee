'use strict';

###**
* @ngdoc service
* @name BB.Models:AdminAddress
*
* @description
* Representation of an Address Object
*
* @property {string} address1 Address 1
* @property {string} address2 Address 2
* @property {string} address3 Address 3
* @property {string} address4 Address 4
* @property {string} address5 Address 5
* @property {string} postcode Postcode/Zipcode
* @property {string} country Country
####

angular.module('BB.Models').factory "Admin.AddressModel", ($q, BBModel, BaseModel, AddressModel) ->

  class Admin_Address extends AddressModel

    ###**
    * @ngdoc method
    * @name distanceFrom
    * @methodOf BB.Models:AdminAddress
    * @description
     * Calculates the address distance using the address and options parameters.
     *
    * @param {string} address Admin address
    * @param {object} options Options object
    *
    * @returns {array} Returns an array of addresses
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
    * Static function that loads an array of addresses from a company object.
    *
    * @returns {Promise} A returned promise
    ###
    @query: (params) ->
      AdminAddressService.query(params)
