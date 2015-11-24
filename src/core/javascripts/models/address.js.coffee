'use strict';


###**
* @ngdoc service
* @name BB.Models:Address
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


angular.module('BB.Models').factory "AddressModel", ($q, BBModel, BaseModel, AddressListService) ->

  class Address extends BaseModel

    ###**
    * @ngdoc method
    * @name addressSingleLine
    * @methodOf BB.Models:Address
    * @description
    * Get a the address as a single comma sepeated line
    *
    * @returns {string} The returned address
    ###
    addressSingleLine: ->
      str = ""
      str += @address1 if @address1
      str += ", " if @address2 && str.length > 0
      str += @address2 if @address2
      str += ", " if @address3 && str.length > 0
      str += @address3 if @address3
      str += ", " if @address4 && str.length > 0
      str += @address4 if @address4
      str += ", " if @address5 && str.length > 0
      str += @address5 if @address5
      str += ", " if @postcode && str.length > 0
      str += @postcode if @postcode
      str

    ###**
    * @ngdoc method
    * @name hasAddress
    * @methodOf BB.Models:Address
    * @description
    * Checks if this is considered a valid address
    *
    * @returns {boolean} If this is a valid address
    ###
    hasAddress: ->
      return @address1 || @address2 || @postcode

    ###**
    * @ngdoc method
    * @name addressCsvLine
    * @methodOf BB.Models:Address
    * @description
    * Get all address fields as a single comma sepeated line - suitable for csv export
    *
    * @returns {string} The returned address
    ###
    addressCsvLine: ->
      str = ""
      str += @address1 if @address1
      str += ", "
      str += @address2 if @address2
      str += ", "
      str += @address3 if @address3
      str += ", "
      str += @address4 if @address4
      str += ", "
      str += @address5 if @address5
      str += ", "
      str += @postcode if @postcode
      str += ", "
      str += @country if @country
      return str

    ###**
    * @ngdoc method
    * @name addressMultiLine
    * @methodOf BB.Models:Address
    * @description
    * Get a the address as multiple lines with line feeds
    *
    * @returns {string} The returned address
    ###
    addressMultiLine: ->
      str = ""
      str += @address1 if @address1
      str += "<br/>" if @address2 && str.length > 0
      str += @address2 if @address2
      str += "<br/>" if @address3 && str.length > 0
      str += @address3 if @address3
      str += "<br/>" if @address4 && str.length > 0
      str += @address4 if @address4
      str += "<br/>" if @address5 && str.length > 0
      str += @address5 if @address5
      str += "<br/>" if @postcode && str.length > 0
      str += @postcode if @postcode
      str

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Address
    * @description
    * Static function that loads an array of addresses from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (prms) ->
      AddressListService.query(prms)