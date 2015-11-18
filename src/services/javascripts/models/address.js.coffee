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


angular.module('BB.Models').factory "Admin.AddressModel", ($q, BBModel, BaseModel, AddressModel) ->

  ###**
  * @ngdoc method
  * @name distanceFrom
  * @methodOf BB.Models:AdminAddress
  * @param {string=} address The admin address
  * @param {array} options The options of admin address
  * @description
  * Calculate the address distance in according of the address and options parameters
  *
  * @returns {array} Returns an array of address 
  ###
  class Admin_Address extends AddressModel

    distanceFrom: (address, options) ->

      @dists ||= []
      @dists[address] ||= Math.round(Math.random() * 50, 0)
      return @dists[address]

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminAddress
    * @description
    * Gets a filtered collection of addresses.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of addresses.
    ###
    @query: (company, page, per_page) ->
      AdminAddressService.query
        company: company
        page: page
        per_page: per_page

angular.module('BB.Models').factory 'AdminAddress', ($injector) ->
  $injector.get('Admin.AddressModel')
