'use strict';

###**
* @ngdoc service
* @name BB.Models:Address
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

angular.module('BB.Models').factory "AddressModel", ($q, BBModel, BaseModel, AddressListService) ->

  class Address extends BaseModel

    constructor: (data) ->
      super(data)
      # Assign value to map_url if the value is an empty String
      # Note: This is not ideal as it will not show a map marker. But the map_url prop should already be set, so this is just a fallback
      if !@map_url or @map_url == ""
        @map_url = "https://www.google.com/maps/@" + @lat + "," + @long + ",17z" if @lat and @long

    ###**
    * @ngdoc method
    * @name addressSingleLine
    * @methodOf BB.Models:Address
    * @description
    * Creates the full address from all the address fields as a single line and comma separated string.
    *
    * @returns {string} Full address
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
    * Returns the first address, second address or the postcode if at least one of these exists.
    *
    * @returns {string} One of these: address1, address2 or postcode
    ###
    hasAddress: ->
      return @address1 || @address2 || @postcode

    ###**
    * @ngdoc method
    * @name addressCsvLine
    * @methodOf BB.Models:Address
    * @description
    * Creates the full address from all the address fields as a single line and comma separated string wich is suitable for csv export.
    *
    * @returns {string} Full address
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
    * Creates the full address from all the address fields as a multiple lines string.
    *
    * @returns {string} Full address
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
    * Static function that loads an array of addresses from a company object.
    *
    * @param {object} prms prms parameter
    *
    * @returns {promise} A promise that on success will return an address list
    ###
    @$query: (prms) ->
      AddressListService.query(prms)

    ###**
    * @ngdoc method
    * @name $getAddress
    * @methodOf BB.Models:Address
    * @description
    * Static function that loads an array of addresses from a company object.
    *
    * @param {object} prms prms parameter
    *
    * @returns {promise} A promise that on success will return the customer address
    ###
    @$getAddress: (prms) ->
      AddressListService.getAddress(prms)

