###**
* @ngdoc service
* @name BB.Services:AddressList
*
* @description
* Representation of an Address List Object
*
* @property {string} address1 First line of the address 
* @property {string} address2 Second line of the address 
* @property {string} address3 Third line of the address 
* @property {string} address4 Fourth line of the address 
* @property {string} address5 Fifth line of the address 
* @property {string} postcode The Postcode/Zipcode
* @property {string} country The country
####


angular.module('BB.Services').factory "AddressListService", ($q, $window, halClient, UriTemplate) ->
 query: (prms) ->

    deferred = $q.defer()
    href = "/api/v1/company/{company_id}/addresses/{post_code}"
    uri = new UriTemplate(href).fillFromObject({company_id: prms.company.id, post_code: prms.post_code })
    halClient.$get(uri, {}).then (addressList) ->
      deferred.resolve(addressList)
    , (err) =>
      deferred.reject(err)
    deferred.promise

 ###**
 * @ngdoc method
 * @name getAddress
 * @methodOf BB.Services:AddressList
 * @param {array} prms The address parameters
 * @description
 * Get the address in according of the prms parameter
 *
 * @returns {Promise} Returns a promise which resolve the getting address
 ###
 getAddress: (prms) ->
   deferred = $q.defer()
   href = "/api/v1/company/{company_id}/addresses/address/{id}"
   uri = new UriTemplate(href).fillFromObject({company_id: prms.company.id, id: prms.id})
   halClient.$get(uri, {}).then (customerAddress) ->
     deferred.resolve(customerAddress)
   , (err) =>
     deferred.reject(err)
   deferred.promise
